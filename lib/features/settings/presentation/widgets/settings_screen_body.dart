import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/bms/presentation/pages/bms_devices_page.dart';
import 'package:green_wheel/features/bms/presentation/utils/bms_permissions.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_searching_rounded,
            color: AppColors.primary,
            size: 48.sp,
          ),
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
              'Connect to your GREEN WHEEL BMS over Classic Bluetooth (SPP) '
              'to view live battery voltage, current, temperature, and SOC.',
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text('Connect to Battery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => _openBmsDevices(context),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Android only · Device name: GREEN_WHEEL_BMS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Future<void> _openBmsDevices(BuildContext context) async {
    final granted = await ensureBmsPermissions();
    if (!context.mounted) return;

    if (granted) {
      context.push(BmsDevicesPage.routeName);
    } else {
      await showBmsPermissionDialog(context);
    }
  }
}
