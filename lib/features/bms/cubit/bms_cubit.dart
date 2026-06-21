import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:injectable/injectable.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';
import 'package:green_wheel/features/bms/data/repositories/bms_bluetooth_repository.dart';

@lazySingleton
class BmsCubit extends Cubit<BmsState> {
  BmsCubit(this._repository) : super(const BmsState());

  final BmsBluetoothRepository _repository;
  StreamSubscription<BmsReading>? _readingsSubscription;
  StreamSubscription<List<BluetoothDiscoveryResult>>? _devicesSubscription;

  static const int _maxHistoryLength = 60;

  Future<void> startScan() async {
    emit(state.copyWith(status: BmsStatus.scanning, clearError: true));

    try {
      final enabled = await _repository.isBluetoothEnabled;
      if (!enabled) {
        final granted = await _repository.requestEnable();
        if (!granted) {
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: 'Bluetooth is disabled. Please enable it.',
            ),
          );
          return;
        }
      }

      final bonded = await _repository.getBondedDevices();
      emit(state.copyWith(bondedDevices: bonded));

      await _devicesSubscription?.cancel();
      _devicesSubscription = _repository.devicesStream.listen(
        (devices) => emit(state.copyWith(devices: devices)),
        onError: (Object error) {
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );

      await _repository.startDiscovery();
    } catch (error) {
      emit(
        state.copyWith(
          status: BmsStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> stopScan() async {
    await _repository.stopDiscovery();
    if (state.status == BmsStatus.scanning) {
      emit(state.copyWith(status: BmsStatus.initial));
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    emit(state.copyWith(status: BmsStatus.connecting, clearError: true));

    try {
      await _repository.connect(device);

      await _readingsSubscription?.cancel();
      _readingsSubscription = _repository.readingsStream.listen(
        _onReadingReceived,
        onError: (Object error) {
          emit(
            state.copyWith(
              status: BmsStatus.error,
              errorMessage: error.toString(),
            ),
          );
        },
      );

      emit(
        state.copyWith(
          status: BmsStatus.connected,
          connectedDevice: device,
          history: const [],
          latestReading: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: BmsStatus.error,
          errorMessage: 'Connection failed: $error',
        ),
      );
    }
  }

  Future<void> disconnect() async {
    await _readingsSubscription?.cancel();
    _readingsSubscription = null;
    await _repository.disconnect();

    emit(
      state.copyWith(
        status: BmsStatus.disconnected,
        clearConnectedDevice: true,
        latestReading: null,
        history: const [],
      ),
    );
  }

  void _onReadingReceived(BmsReading reading) {
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
  }

  @override
  Future<void> close() async {
    await _readingsSubscription?.cancel();
    await _devicesSubscription?.cancel();
    await _repository.stopDiscovery();
    return super.close();
  }
}
