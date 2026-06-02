import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/analytics/data/models/analytics_time_range.dart';

class TimeRangeSelector extends StatelessWidget {
  final AnalyticsTimeRange selected;
  final ValueChanged<AnalyticsTimeRange> onChanged;

  const TimeRangeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightInputFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: AnalyticsTimeRange.values.map((range) {
          final isSelected = range == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(range),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.darkInputFill
                          : AppColors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  translate(range.labelKey),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    fontSize: 13.sp,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
