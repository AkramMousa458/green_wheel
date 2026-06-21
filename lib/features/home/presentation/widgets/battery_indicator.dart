import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class BatteryIndicator extends StatelessWidget {
  final double percentage;
  final bool showPlaceholder;

  const BatteryIndicator({
    super.key,
    required this.percentage,
    this.showPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.darkCard.withValues(alpha: 0.3)
            : AppColors.lightCard,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
      child: SizedBox(
        height: 220.w,
        width: 220.w,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16.w,
              color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
              strokeCap: StrokeCap.round,
            ),
            CircularProgressIndicator(
              value: showPlaceholder ? 0 : percentage / 100,
              strokeWidth: 16.w,
              color: showPlaceholder
                  ? (isDark ? AppColors.darkInputFill : AppColors.lightBorder)
                  : AppColors.primary,
              strokeCap: StrokeCap.round,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showPlaceholder ? '--' : '${percentage.toInt()}%',
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.lightTextPrimary,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  translate('battery_soc').toUpperCase(),
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
