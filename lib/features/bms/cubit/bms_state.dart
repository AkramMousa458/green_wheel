import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

enum BmsStatus {
  initial,
  scanning,
  connecting,
  connected,
  disconnected,
  error,
}

class BmsState extends Equatable {
  final BmsStatus status;
  final List<BluetoothDiscoveryResult> devices;
  final List<BluetoothDevice> bondedDevices;
  final BluetoothDevice? connectedDevice;
  final BmsReading? latestReading;
  final List<BmsReading> history;
  final String? errorMessage;

  const BmsState({
    this.status = BmsStatus.initial,
    this.devices = const [],
    this.bondedDevices = const [],
    this.connectedDevice,
    this.latestReading,
    this.history = const [],
    this.errorMessage,
  });

  BmsState copyWith({
    BmsStatus? status,
    List<BluetoothDiscoveryResult>? devices,
    List<BluetoothDevice>? bondedDevices,
    BluetoothDevice? connectedDevice,
    BmsReading? latestReading,
    List<BmsReading>? history,
    String? errorMessage,
    bool clearError = false,
    bool clearConnectedDevice = false,
    bool clearLatestReading = false,
  }) {
    return BmsState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      bondedDevices: bondedDevices ?? this.bondedDevices,
      connectedDevice:
          clearConnectedDevice ? null : connectedDevice ?? this.connectedDevice,
      latestReading:
          clearLatestReading ? null : latestReading ?? this.latestReading,
      history: history ?? this.history,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        devices,
        bondedDevices,
        connectedDevice,
        latestReading,
        history,
        errorMessage,
      ];
}
