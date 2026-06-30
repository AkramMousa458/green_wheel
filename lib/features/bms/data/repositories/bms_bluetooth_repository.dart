import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:injectable/injectable.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

@lazySingleton
class BmsBluetoothRepository {
  static const String targetDeviceName = 'Green Wheel BMS';

  /// Returns true when [name] matches the target BMS device, ignoring case and
  /// treating spaces and underscores as equivalent separators. This keeps the
  /// app resilient to the ESP32 advertising "Green Wheel BMS" while older
  /// firmware/builds may have used "GREEN_WHEEL_BMS".
  static bool isTargetDeviceName(String? name) {
    if (name == null) return false;
    String normalize(String value) =>
        value.toUpperCase().replaceAll(RegExp(r'[\s_]+'), '');
    return normalize(name) == normalize(targetDeviceName);
  }
  static const String _logTag = '[BMS]';
  static const int _maxReconnectAttempts = 2;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  BluetoothDevice? _lastConnectDevice;
  StreamSubscription<Uint8List>? _inputSubscription;
  StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;
  Timer? _keepAliveTimer;

  bool _intentionalDisconnect = false;
  int _reconnectAttempts = 0;

  final StreamController<BmsReading> _readingsController =
      StreamController<BmsReading>.broadcast();

  final StreamController<List<BluetoothDiscoveryResult>> _devicesController =
      StreamController<List<BluetoothDiscoveryResult>>.broadcast();

  final StreamController<void> _connectionLostController =
      StreamController<void>.broadcast();

  final List<BluetoothDiscoveryResult> _discoveredDevices = [];
  String _lineBuffer = '';
  static final RegExp _lineDelimiter = RegExp(r'\r?\n');

  Stream<BmsReading> get readingsStream => _readingsController.stream;

  Stream<List<BluetoothDiscoveryResult>> get devicesStream =>
      _devicesController.stream;

  Stream<void> get connectionLostStream => _connectionLostController.stream;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  bool get isConnected => _connection?.isConnected ?? false;

  Future<bool> get isBluetoothEnabled async =>
      await _bluetooth.isEnabled ?? false;

  Future<bool> requestEnable() async => await _bluetooth.requestEnable() ?? false;

  Future<List<BluetoothDevice>> getBondedDevices() async {
    return _bluetooth.getBondedDevices();
  }

  Future<void> startDiscovery() async {
    log('$_logTag Starting Bluetooth discovery');
    await stopDiscovery();
    _discoveredDevices.clear();
    _emitDevices();

    _discoverySubscription = _bluetooth.startDiscovery().listen(
      (result) {
        final alreadyListed = _discoveredDevices.any(
          (d) => d.device.address == result.device.address,
        );
        if (!alreadyListed) {
          _discoveredDevices.add(result);
          log(
            '$_logTag Device discovered: '
            '${result.device.name ?? "unknown"} (${result.device.address})',
          );
          _emitDevices();
        }
      },
      onError: (Object error) {
        log('$_logTag Discovery error: $error');
        _devicesController.addError(error);
      },
      onDone: () => log('$_logTag Discovery finished'),
    );
  }

  Future<void> stopDiscovery() async {
    log('$_logTag Stopping Bluetooth discovery');
    await _discoverySubscription?.cancel();
    _discoverySubscription = null;
    await _bluetooth.cancelDiscovery();
  }

  Future<void> connect(
    BluetoothDevice device, {
    bool isReconnect = false,
  }) async {
    log(
      '$_logTag Connecting to '
      '${device.name ?? targetDeviceName} (${device.address})'
      '${isReconnect ? " [reconnect attempt $_reconnectAttempts]" : ""}',
    );

    _intentionalDisconnect = false;
    _lastConnectDevice = device;
    if (!isReconnect) {
      _reconnectAttempts = 0;
    }

    await _tearDownConnection(intentional: true);
    if (_discoverySubscription != null) {
      await stopDiscovery();
    }
    await _ensureBonded(device.address);

    final bondedDevice = await _resolveBondedDevice(device);
    // Let ESP32 BT stack settle after scan/bonding teardown.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    _connection = await BluetoothConnection.toAddress(bondedDevice.address);
    _connectedDevice = bondedDevice;
    _lineBuffer = '';

    final input = _connection!.input;
    if (input == null) {
      log('$_logTag Connect failed: input stream is null');
      throw StateError('Bluetooth input stream is unavailable after connect.');
    }

    log('$_logTag Connected, listening for incoming data');

    _inputSubscription = input.listen(
      _onDataReceived,
      onDone: () {
        log(
          '$_logTag Input stream closed — ESP32 closed the socket '
          '(onDisconnected by remote). No telemetry was received.',
        );
        _handleConnectionLost();
      },
      onError: (Object error) {
        log('$_logTag Input stream error: $error');
        _handleConnectionLost();
      },
    );

    _startKeepAlive();
    log('$_logTag Connection setup complete');
  }

  Future<void> disconnect({bool notifyConnectionLost = false}) async {
    _intentionalDisconnect = !notifyConnectionLost;
    if (_intentionalDisconnect) {
      _lastConnectDevice = null;
      _reconnectAttempts = 0;
    }

    await _tearDownConnection(
      intentional: _intentionalDisconnect,
      notifyConnectionLost: notifyConnectionLost,
    );
  }

  Future<void> _tearDownConnection({
    required bool intentional,
    bool notifyConnectionLost = false,
  }) async {
    final device = _connectedDevice;
    log(
      '$_logTag Disconnecting'
      '${device != null ? " from ${device.name ?? targetDeviceName} (${device.address})" : ""}'
      '${notifyConnectionLost ? " (connection lost)" : ""}',
    );

    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    await _inputSubscription?.cancel();
    _inputSubscription = null;

    final connection = _connection;
    _connection = null;
    _connectedDevice = null;
    _lineBuffer = '';

    if (connection != null) {
      try {
        if (intentional) {
          await connection.finish();
        } else {
          await connection.close();
        }
      } catch (error) {
        log('$_logTag Connection close error: $error');
      }
    }

    if (notifyConnectionLost && !_connectionLostController.isClosed) {
      log('$_logTag Notifying listeners: connection lost');
      _connectionLostController.add(null);
    }

    log('$_logTag Disconnected');
  }

  void _handleConnectionLost() {
    if (_intentionalDisconnect) {
      log('$_logTag Connection lost ignored (user disconnect in progress)');
      return;
    }

    log('$_logTag Connection lost handler triggered');
    unawaited(_tearDownConnection(intentional: false));

    final device = _lastConnectDevice;
    if (device != null && _reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      log(
        '$_logTag Scheduling reconnect $_reconnectAttempts/$_maxReconnectAttempts '
        'in ${_reconnectDelay.inSeconds}s',
      );

      Future<void>.delayed(_reconnectDelay, () async {
        if (_intentionalDisconnect || _lastConnectDevice == null) {
          return;
        }

        try {
          await connect(device, isReconnect: true);
          log('$_logTag Reconnect succeeded');
        } catch (error) {
          log('$_logTag Reconnect failed: $error');
          _handleConnectionLost();
        }
      });
      return;
    }

    log('$_logTag All reconnect attempts exhausted');
    unawaited(
      _tearDownConnection(intentional: false, notifyConnectionLost: true),
    );
  }

  void _startKeepAlive() {
    _keepAliveTimer?.cancel();
    // First keep-alive only after connection stabilizes; ESP32 may drop if
    // pinged too early on some boards.
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      final connection = _connection;
      if (connection == null || !connection.isConnected) return;

      try {
        connection.output.add(Uint8List.fromList([0x0A]));
        log('$_logTag Keep-alive ping sent');
      } catch (error) {
        log('$_logTag Keep-alive ping failed: $error');
      }
    });
  }

  Future<void> _ensureBonded(String address) async {
    final bondState = await _bluetooth.getBondStateForAddress(address);
    log('$_logTag Bond state for $address: $bondState');

    if (bondState.isBonded) {
      return;
    }

    log('$_logTag Pairing with device before connect');
    final bonded = await _bluetooth.bondDeviceAtAddress(address);
    log('$_logTag Pairing result: $bonded');
  }

  Future<BluetoothDevice> _resolveBondedDevice(BluetoothDevice device) async {
    final bonded = await _bluetooth.getBondedDevices();
    for (final entry in bonded) {
      if (entry.address == device.address) {
        log('$_logTag Using bonded device entry for ${entry.address}');
        return entry;
      }
    }
    return device;
  }

  void _onDataReceived(Uint8List data) {
    _reconnectAttempts = 0;
    final chunk = utf8.decode(data, allowMalformed: true);
    log('$_logTag Raw data received (${data.length} bytes): $chunk');

    _lineBuffer += chunk;

    final lines = _lineBuffer.split(_lineDelimiter);
    _lineBuffer = lines.removeLast();

    for (final line in lines) {
      final reading = BmsReading.tryParse(line);
      if (reading != null) {
        log('$_logTag Parsed reading: ${reading.toJson()}');
        if (!_readingsController.isClosed) {
          _readingsController.add(reading);
        }
      } else if (line.trim().isNotEmpty) {
        log('$_logTag Ignored line (parse failed): ${line.trim()}');
      }
    }
  }

  void _emitDevices() {
    if (!_devicesController.isClosed) {
      _devicesController.add(List.unmodifiable(_discoveredDevices));
    }
  }

  @disposeMethod
  Future<void> dispose() async {
    await stopDiscovery();
    await disconnect();
    await _readingsController.close();
    await _devicesController.close();
    await _connectionLostController.close();
  }
}
