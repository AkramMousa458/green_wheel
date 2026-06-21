import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/base/presentation/screens/base_screen.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/presentation/pages/bms_devices_page.dart';
import 'package:green_wheel/features/bms/presentation/utils/bms_permissions.dart';
import 'package:green_wheel/features/bms/presentation/utils/bms_telemetry_mapper.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocBuilder<BmsCubit, BmsState>(
      builder: (context, state) {
        final connected = BmsTelemetryMapper.isConnected(state);
        final deviceName = state.connectedDevice?.name ?? 'GREEN_WHEEL_BMS';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                connected
                    ? Icons.bluetooth_connected_rounded
                    : Icons.bluetooth_searching_rounded,
                color: connected ? AppColors.primary : AppColors.grey,
                size: 48.sp,
              ),
              SizedBox(height: 24.h),
              Text(
                connected
                    ? translate('connected_to_device')
                    : translate('scanning_area'),
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
                  connected
                      ? '$deviceName · ${translate("recording_data")}'
                      : 'Connect to your GREEN WHEEL BMS over Classic Bluetooth (SPP) '
                          'to view live battery data on the Home, Analytics, and Alerts tabs.',
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
              if (connected) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('View Live Dashboard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () => BaseScreen.changeTab(context, 0),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bluetooth_disabled_rounded),
                    label: Text(translate('disconnect')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () => context.read<BmsCubit>().disconnect(),
                  ),
                ),
              ] else
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
      },
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
