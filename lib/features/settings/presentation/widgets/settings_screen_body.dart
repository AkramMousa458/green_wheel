import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/settings/data/models/settings_models.dart';
import 'package:green_wheel/features/settings/presentation/widgets/bluetooth_device_card.dart';
import 'package:green_wheel/features/settings/presentation/widgets/scanning_indicator.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  static const List<BluetoothDeviceModel> _devices = [
    BluetoothDeviceModel(
      deviceName: 'greenwheel_bMS',
      signalStrengthKey: 'strong_signal',
      signalIcon: Icons.signal_cellular_alt_rounded,
      deviceIcon: Icons.battery_charging_full_rounded,
      isTarget: true,
    ),
    BluetoothDeviceModel(
      deviceName: 'unknown_ble_device',
      signalStrengthKey: 'weak_signal',
      signalIcon: Icons.signal_cellular_alt_1_bar_rounded,
      deviceIcon: Icons.devices_other_rounded,
      isTarget: false,
    ),
    BluetoothDeviceModel(
      deviceName: 'smarttv_livingroom',
      signalStrengthKey: 'medium_signal',
      signalIcon: Icons.signal_cellular_alt_2_bar_rounded,
      deviceIcon: Icons.tv_rounded,
      isTarget: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ScanningIndicator(),
          SizedBox(height: 24.h),
          Text(
            translate('scanning_area'),
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              translate('scanning_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translate('available_devices').toUpperCase(),
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ..._devices.map(
            (device) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: BluetoothDeviceCard(
                device: device,
                onConnect: device.isTarget ? () {} : null,
              ),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
