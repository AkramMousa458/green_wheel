import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/base/presentation/screens/base_screen.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/data/repositories/bms_bluetooth_repository.dart';

class BmsDevicesPage extends StatefulWidget {
  const BmsDevicesPage({super.key});

  static const String routeName = '/bms-devices';

  @override
  State<BmsDevicesPage> createState() => _BmsDevicesPageState();
}

class _BmsDevicesPageState extends State<BmsDevicesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BmsCubit>().startScan();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to Battery'),
        backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
        foregroundColor: isDark ? AppColors.white : AppColors.lightTextPrimary,
      ),
      body: BlocConsumer<BmsCubit, BmsState>(
        listener: (context, state) {
          if (state.status == BmsStatus.connected) {
            context.go(BaseScreen.routeName);
          }
        },
        builder: (context, state) {
          final targetDevices = _collectTargetDevices(state);

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<BmsCubit>().startScan(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              children: [
                if (state.status == BmsStatus.scanning)
                  const LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.darkInputFill,
                  ),
                if (state.status == BmsStatus.scanning) SizedBox(height: 8.h),
                if (state.status == BmsStatus.connecting)
                  const LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.darkInputFill,
                  ),
                if (state.status == BmsStatus.connecting) SizedBox(height: 8.h),
                if (state.status == BmsStatus.error && state.errorMessage != null)
                  _ErrorBanner(message: state.errorMessage!),
                if (state.status == BmsStatus.error) SizedBox(height: 12.h),
                Text(
                  'Available BMS Devices',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.white
                        : AppColors.lightTextPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Looking for "${BmsBluetoothRepository.targetDeviceName}" over Classic Bluetooth (SPP).',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                if (targetDevices.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Center(
                      child: Text(
                        state.status == BmsStatus.scanning
                            ? 'Scanning for devices...'
                            : 'No GREEN WHEEL BMS devices found.\nMake sure the ESP32 is powered on and paired.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )
                else
                  ...targetDevices.map(
                    (device) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _DeviceTile(
                        device: device,
                        isConnecting: state.status == BmsStatus.connecting,
                        onConnect: () =>
                            context.read<BmsCubit>().connectToDevice(device),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<BluetoothDevice> _collectTargetDevices(BmsState state) {
    final devices = <String, BluetoothDevice>{};

    for (final bonded in state.bondedDevices) {
      if (_isTargetDevice(bonded.name)) {
        devices[bonded.address] = bonded;
      }
    }

    for (final result in state.devices) {
      if (_isTargetDevice(result.device.name)) {
        devices[result.device.address] = result.device;
      }
    }

    return devices.values.toList();
  }

  bool _isTargetDevice(String? name) {
    if (name == null) return false;
    return name.toUpperCase() == BmsBluetoothRepository.targetDeviceName;
  }
}

class _DeviceTile extends StatelessWidget {
  final BluetoothDevice device;
  final bool isConnecting;
  final VoidCallback onConnect;

  const _DeviceTile({
    required this.device,
    required this.isConnecting,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(Icons.battery_charging_full_rounded,
              color: AppColors.primary, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name ?? BmsBluetoothRepository.targetDeviceName,
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  device.address,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isConnecting ? null : onConnect,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.black,
            ),
            child: Text(isConnecting ? 'Connecting...' : 'Connect'),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Text(
        message,
        style: TextStyle(color: AppColors.error, fontSize: 13.sp),
      ),
    );
  }
}
