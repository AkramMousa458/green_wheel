import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/analytics/data/models/telemetry_metric_model.dart';
import 'package:green_wheel/features/analytics/presentation/widgets/mini_line_chart.dart';

class TelemetryMetricCard extends StatelessWidget {
  final TelemetryMetricModel metric;

  const TelemetryMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final titleColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final valueColor = metric.highlightValue
        ? AppColors.primary
        : (isDark ? AppColors.white : AppColors.lightTextPrimary);
    final chartColor = metric.highlightValue
        ? AppColors.primary
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(metric.icon, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  translate(metric.titleKey),
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    metric.value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    metric.unit,
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 56.h,
            width: double.infinity,
            child: MiniLineChart(
              data: metric.chartData,
              lineColor: chartColor,
              showGradient: metric.highlightValue,
            ),
          ),
        ],
      ),
    );
  }
}
