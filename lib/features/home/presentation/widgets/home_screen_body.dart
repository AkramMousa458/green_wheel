import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/widgets/language_toggle_button.dart';
import 'package:green_wheel/core/widgets/theme_toggle_button.dart';
import 'package:green_wheel/features/home/presentation/widgets/battery_indicator.dart';
import 'package:green_wheel/features/home/presentation/widgets/metric_card.dart';
import 'package:green_wheel/features/home/presentation/widgets/status_card.dart';
import 'package:green_wheel/features/home/presentation/widgets/temperature_card.dart';

import 'package:flutter_translate/flutter_translate.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          // Row(children: [ThemeToggleButton(), LanguageToggleButton()]),
          const StatusCard(),
          SizedBox(height: 40.h),
          const BatteryIndicator(percentage: 85),
          SizedBox(height: 40.h),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: translate('voltage'),
                  value: '72.4V',
                  icon: Icons.bolt_rounded,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: MetricCard(
                  title: translate('current'),
                  value: '12.5A',
                  icon: Icons.speed_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TemperatureCard(temperature: '32°C', status: translate('optimal')),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
