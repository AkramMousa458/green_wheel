import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class StatusCard extends StatelessWidget {
  final bool connected;
  final bool hasFault;
  final bool waitingForData;

  const StatusCard({
    super.key,
    this.connected = false,
    this.hasFault = false,
    this.waitingForData = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final statusColor = !connected
        ? AppColors.grey
        : hasFault
            ? AppColors.error
            : waitingForData
                ? AppColors.warning500
                : AppColors.primary;
    final statusIcon = !connected
        ? Icons.bluetooth_disabled_rounded
        : hasFault
            ? Icons.warning_amber_rounded
            : waitingForData
                ? Icons.bluetooth_searching_rounded
                : Icons.gpp_good_outlined;
    final statusLabel = !connected
        ? translate('offline').toUpperCase()
        : hasFault
            ? translate('critical').toUpperCase()
            : waitingForData
                ? translate('waiting_for_connection').toUpperCase()
                : translate('status_safe').toUpperCase();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? statusColor.withValues(alpha: 0.3)
              : AppColors.lightBorder,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            statusLabel,
            style: TextStyle(
              color: statusColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
