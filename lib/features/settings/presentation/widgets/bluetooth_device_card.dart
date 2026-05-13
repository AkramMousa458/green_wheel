import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/settings/data/models/settings_models.dart';

class BluetoothDeviceCard extends StatelessWidget {
  final BluetoothDeviceModel device;
  final VoidCallback? onConnect;

  const BluetoothDeviceCard({
    super.key,
    required this.device,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: device.isTarget
              ? AppColors.primary.withValues(alpha: 0.8)
              : (isDark ? AppColors.darkInputFill : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: device.isTarget
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : (isDark ? AppColors.darkInputFill : AppColors.lightBorder),
              shape: BoxShape.circle,
            ),
            child: Icon(
              device.deviceIcon,
              color: device.isTarget
                  ? AppColors.primary
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(device.deviceName),
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      device.signalIcon,
                      color: device.isTarget
                          ? AppColors.primary
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      translate(device.signalStrengthKey),
                      style: TextStyle(
                        color: device.isTarget
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (device.isTarget) ...[
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black, // Dark text on primary green button
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                elevation: 0,
              ),
              child: Text(
                translate('connect'),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
