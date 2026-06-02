import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/analytics/data/analytics_telemetry_data.dart';
import 'package:green_wheel/features/analytics/data/models/analytics_time_range.dart';
import 'package:green_wheel/features/analytics/presentation/widgets/analytics_status_row.dart';
import 'package:green_wheel/features/analytics/presentation/widgets/telemetry_metric_card.dart';
import 'package:green_wheel/features/analytics/presentation/widgets/time_range_selector.dart';

class AnalyticsScreenBody extends StatefulWidget {
  const AnalyticsScreenBody({super.key});

  @override
  State<AnalyticsScreenBody> createState() => _AnalyticsScreenBodyState();
}

class _AnalyticsScreenBodyState extends State<AnalyticsScreenBody> {
  AnalyticsTimeRange _selectedRange = AnalyticsTimeRange.twentyFourHours;

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('live_telemetry'),
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          const AnalyticsStatusRow(),
          SizedBox(height: 24.h),
          TimeRangeSelector(
            selected: _selectedRange,
            onChanged: (range) => setState(() => _selectedRange = range),
          ),
          SizedBox(height: 24.h),
          ...AnalyticsTelemetryData.metrics.map(
            (metric) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: TelemetryMetricCard(metric: metric),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
