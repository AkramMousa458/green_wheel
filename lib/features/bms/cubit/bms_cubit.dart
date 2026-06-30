import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:injectable/injectable.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';
import 'package:green_wheel/features/bms/data/repositories/bms_bluetooth_repository.dart';

@lazySingleton
class BmsCubit extends Cubit<BmsState> {
  static const String _logTag = '[BMS]';

  BmsCubit(this._repository) : super(const BmsState()) {
    log('$_logTag Cubit initialized');
    _connectionLostSubscription = _repository.connectionLostStream.listen(
      (_) => _onConnectionLost(),
    );
  }

  final BmsBluetoothRepository _repository;
  StreamSubscription<BmsReading>? _readingsSubscription;
  StreamSubscription<List<BluetoothDiscoveryResult>>? _devicesSubscription;
  StreamSubscription<void>? _connectionLostSubscription;

  static const int _maxHistoryLength = 60;

  Future<void> startScan() async {
    log('$_logTag Starting scan');
    emit(state.copyWith(status: BmsStatus.scanning, clearError: true));

    try {
      final enabled = await _repository.isBluetoothEnabled;
      if (!enabled) {
        log('$_logTag Bluetooth disabled, requesting enable');
        final granted = await _repository.requestEnable();
        if (!granted) {
          log('$_logTag Bluetooth enable request denied');
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: 'Bluetooth is disabled. Please enable it.',
            ),
          );
          return;
        }
        log('$_logTag Bluetooth enabled');
      }

      final bonded = await _repository.getBondedDevices();
      log('$_logTag Bonded devices: ${bonded.length}');
      emit(state.copyWith(bondedDevices: bonded));

      await _devicesSubscription?.cancel();
      _devicesSubscription = _repository.devicesStream.listen(
        (devices) {
          log('$_logTag Device list updated: ${devices.length} device(s)');
          emit(state.copyWith(devices: devices));
        },
        onError: (Object error) {
          log('$_logTag Device stream error: $error');
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );

      await _repository.startDiscovery();
      log('$_logTag Scan started');
    } catch (error) {
      log('$_logTag Scan failed: $error');
      emit(
        state.copyWith(status: BmsStatus.error, errorMessage: error.toString()),
      );
    }
  }

  Future<void> stopScan() async {
    log('$_logTag Stopping scan');
    await _repository.stopDiscovery();
    if (state.status == BmsStatus.scanning) {
      emit(state.copyWith(status: BmsStatus.initial));
    }
    log('$_logTag Scan stopped');
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    log(
      '$_logTag Connect requested: '
      '${device.name ?? "unknown"} (${device.address})',
    );
    emit(state.copyWith(status: BmsStatus.connecting, clearError: true));

    try {
      await _readingsSubscription?.cancel();
      log('$_logTag Subscribing to readings stream');
      _readingsSubscription = _repository.readingsStream.listen(
        _onReadingReceived,
        onError: (Object error) {
          log('$_logTag Readings stream error: $error');
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );

      await _repository.connect(device);

      if (!_repository.isConnected) {
        log('$_logTag Connect failed: socket closed immediately');
        throw StateError('Bluetooth socket closed immediately after connect.');
      }

      log('$_logTag Connect succeeded, waiting for telemetry');
      emit(
        state.copyWith(
          status: BmsStatus.connected,
          connectedDevice: device,
          history: const [],
          clearLatestReading: true,
        ),
      );
    } catch (error) {
      log('$_logTag Connect failed: $error');
      await _readingsSubscription?.cancel();
      _readingsSubscription = null;
      emit(
        state.copyWith(
          status: BmsStatus.error,
          errorMessage: 'Connection failed: $error',
        ),
      );
    }
  }

  Future<void> disconnect() async {
    final device = state.connectedDevice;
    log(
      '$_logTag Disconnect requested'
      '${device != null ? " from ${device.name ?? "unknown"} (${device.address})" : ""}',
    );

    await _readingsSubscription?.cancel();
    _readingsSubscription = null;
    await _repository.disconnect();

    emit(
      state.copyWith(
        status: BmsStatus.disconnected,
        clearConnectedDevice: true,
        clearLatestReading: true,
        history: const [],
      ),
    );
    log('$_logTag Disconnected');
  }

  void _onConnectionLost() {
    if (state.status != BmsStatus.connected &&
        state.status != BmsStatus.connecting) {
      log('$_logTag Connection lost ignored (status: ${state.status})');
      return;
    }

    log('$_logTag Connection lost unexpectedly');
    _readingsSubscription?.cancel();
    _readingsSubscription = null;

    emit(
      state.copyWith(
        status: BmsStatus.disconnected,
        clearConnectedDevice: true,
        clearLatestReading: true,
        history: const [],
        errorMessage: 'Bluetooth connection lost.',
      ),
    );
  }

  void _onReadingReceived(BmsReading reading) {
    log('$_logTag Reading received in cubit: ${reading.toJson()}');
    final updatedHistory = [...state.history, reading];
    if (updatedHistory.length > _maxHistoryLength) {
      updatedHistory.removeAt(0);
    }

    emit(
      state.copyWith(
        status: BmsStatus.connected,
        latestReading: reading,
        history: updatedHistory,
      ),
    );
    log('$_logTag State updated with reading (history: ${updatedHistory.length})');
  }

  @override
  Future<void> close() async {
    log('$_logTag Cubit closing');
    await _readingsSubscription?.cancel();
    await _devicesSubscription?.cancel();
    await _connectionLostSubscription?.cancel();
    await _repository.stopDiscovery();
    return super.close();
  }
}
