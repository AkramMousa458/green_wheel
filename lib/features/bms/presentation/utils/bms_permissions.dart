import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests Bluetooth + Location permissions required for Classic SPP on Android.
Future<bool> ensureBmsPermissions() async {
  final permissions = <Permission>[
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ];

  final statuses = await permissions.request();
  return statuses.values.every((status) => status.isGranted);
}

Future<void> showBmsPermissionDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Permissions Required'),
      content: const Text(
        'Bluetooth and Location permissions are required to scan for and connect '
        'to the GREEN WHEEL BMS device over Classic Bluetooth.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
