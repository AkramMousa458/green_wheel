import 'package:flutter/material.dart';

class BluetoothDeviceModel {
  final String deviceName;
  final String signalStrengthKey;
  final IconData signalIcon;
  final IconData deviceIcon;
  final bool isTarget;

  const BluetoothDeviceModel({
    required this.deviceName,
    required this.signalStrengthKey,
    required this.signalIcon,
    required this.deviceIcon,
    this.isTarget = false,
  });
}
