import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class AnalyticsStatusRow extends StatelessWidget {
  final bool connected;

  const AnalyticsStatusRow({super.key, this.connected = false});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Wrap(
      spacing: 20.w,
      runSpacing: 8.h,
      children: [
        _StatusChip(
          dotColor: connected ? AppColors.primary : AppColors.grey,
          label: connected
              ? translate('system_online')
              : translate('offline'),
          textColor: mutedColor,
          glowDot: connected,
        ),
        _StatusChip(
          dotColor: connected ? AppColors.primary : mutedColor,
          label: connected
              ? translate('recording_data')
              : translate('waiting_for_connection'),
          textColor: mutedColor,
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Color dotColor;
  final String label;
  final Color textColor;
  final bool glowDot;

  const _StatusChip({
    required this.dotColor,
    required this.label,
    required this.textColor,
    this.glowDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            boxShadow: glowDot
                ? [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.6),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
