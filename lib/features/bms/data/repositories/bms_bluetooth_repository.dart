import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:injectable/injectable.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

@lazySingleton
class BmsBluetoothRepository {
  static const String targetDeviceName = 'GREEN_WHEEL_BMS';

  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  StreamSubscription<Uint8List>? _inputSubscription;
  StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;

  final StreamController<BmsReading> _readingsController =
      StreamController<BmsReading>.broadcast();

  final StreamController<List<BluetoothDiscoveryResult>> _devicesController =
      StreamController<List<BluetoothDiscoveryResult>>.broadcast();

  final List<BluetoothDiscoveryResult> _discoveredDevices = [];
  String _lineBuffer = '';

  Stream<BmsReading> get readingsStream => _readingsController.stream;

  Stream<List<BluetoothDiscoveryResult>> get devicesStream =>
      _devicesController.stream;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  bool get isConnected => _connection?.isConnected ?? false;

  Future<bool> get isBluetoothEnabled async =>
      await _bluetooth.isEnabled ?? false;

  Future<bool> requestEnable() async => await _bluetooth.requestEnable() ?? false;

  Future<List<BluetoothDevice>> getBondedDevices() async {
    return _bluetooth.getBondedDevices();
  }

  Future<void> startDiscovery() async {
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
          _emitDevices();
        }
      },
      onError: (Object error) {
        _devicesController.addError(error);
      },
    );
  }

  Future<void> stopDiscovery() async {
    await _discoverySubscription?.cancel();
    _discoverySubscription = null;
    await _bluetooth.cancelDiscovery();
  }

  Future<void> connect(BluetoothDevice device) async {
    await disconnect();
    await stopDiscovery();

    _connection = await BluetoothConnection.toAddress(device.address);
    _connectedDevice = device;
    _lineBuffer = '';

    _inputSubscription = _connection!.input?.listen(
      _onDataReceived,
      onDone: disconnect,
      onError: (_) => disconnect(),
    );
  }

  Future<void> disconnect() async {
    await _inputSubscription?.cancel();
    _inputSubscription = null;

    await _connection?.finish();
    _connection = null;
    _connectedDevice = null;
    _lineBuffer = '';
  }

  void _onDataReceived(Uint8List data) {
    _lineBuffer += utf8.decode(data, allowMalformed: true);

    while (_lineBuffer.contains('\n')) {
      final index = _lineBuffer.indexOf('\n');
      final line = _lineBuffer.substring(0, index);
      _lineBuffer = _lineBuffer.substring(index + 1);

      final reading = BmsReading.tryParse(line);
      if (reading != null && !_readingsController.isClosed) {
        _readingsController.add(reading);
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
  }
}
