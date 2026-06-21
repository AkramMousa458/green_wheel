import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

class BmsGaugeCard extends StatelessWidget {
  final BmsReading? reading;

  const BmsGaugeCard({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final soc = reading?.soc ?? 0;
    final hasFault = reading?.fault ?? false;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasFault
              ? AppColors.error
              : (isDark ? AppColors.darkInputFill : AppColors.lightBorder),
        ),
      ),
      child: Column(
        children: [
          Text(
            'State of Charge',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 160.h,
            width: 160.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: 56.r,
                    sections: [
                      PieChartSectionData(
                        value: soc.toDouble(),
                        color: hasFault ? AppColors.error : AppColors.primary,
                        radius: 18.r,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (100 - soc).toDouble(),
                        color: isDark
                            ? AppColors.darkInputFill
                            : AppColors.lightBorder,
                        radius: 18.r,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$soc%',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasFault)
                      Text(
                        'FAULT',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
