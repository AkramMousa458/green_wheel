import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

class BmsLiveChart extends StatelessWidget {
  final List<BmsReading> history;
  final String title;
  final Color lineColor;
  final double Function(BmsReading reading) valueSelector;

  const BmsLiveChart({
    super.key,
    required this.history,
    required this.title,
    required this.lineColor,
    required this.valueSelector,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

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
          Text(
            title,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 140.h,
            child: history.length < 2
                ? Center(
                    child: Text(
                      'Waiting for live data...',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                : LineChart(_buildChartData(isDark)),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(bool isDark) {
    final spots = history
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.key.toDouble(),
            valueSelector(entry.value),
          ),
        )
        .toList();

    final values = history.map(valueSelector).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY).abs() * 0.15 + 0.5;

    return LineChartData(
      minY: minY - padding,
      maxY: maxY + padding,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
          strokeWidth: 1,
        ),
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: lineColor,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: lineColor.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}
