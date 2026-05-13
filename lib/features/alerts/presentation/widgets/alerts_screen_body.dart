import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/active_priority_card.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/attention_card.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/recent_event_card.dart';
import 'package:green_wheel/features/alerts/data/models/alert_models.dart';

class AlertsScreenBody extends StatelessWidget {
  const AlertsScreenBody({super.key});

  static const List<ActivePriorityModel> _activePriorities = [
    ActivePriorityModel(
      titleKey: 'battery_high_temp',
      descriptionKey: 'battery_high_temp_desc',
      pillTextKey: 'critical',
      buttonTextKey: 'initiate_diagnostics',
      icon: Icons.thermostat_outlined,
      accentColor: Color(0xFFF08080),
      isButtonOutlined: false,
    ),
    ActivePriorityModel(
      titleKey: 'low_range_warning',
      descriptionKey: 'low_range_warning_desc',
      pillTextKey: 'warning',
      buttonTextKey: 'find_charger',
      icon: Icons.battery_alert_outlined,
      accentColor: AppColors.primary,
      isButtonOutlined: true,
    ),
  ];

  static const List<RecentEventModel> _recentEvents = [
    RecentEventModel(
      titleKey: 'connection_dropped',
      descriptionKey: 'connection_dropped_desc',
      timeKey: 'time_10_42',
      icon: Icons.wifi_off_rounded,
      isPrimaryColor: false,
    ),
    RecentEventModel(
      titleKey: 'firmware_update',
      descriptionKey: 'firmware_update_desc',
      timeKey: 'time_yesterday',
      icon: Icons.system_update_alt_rounded,
      isPrimaryColor: true,
    ),
  ];

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
            translate('system_alerts'),
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            translate('system_alerts_desc'),
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 24.h),
          AttentionCard(
            title: translate('attention_required'),
            description: translate('attention_required_desc'),
          ),
          SizedBox(height: 32.h),
          _buildSectionTitle(translate('active_priority'), isDark),
          SizedBox(height: 16.h),
          ..._activePriorities.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: ActivePriorityCard(
              title: translate(item.titleKey),
              description: translate(item.descriptionKey),
              pillText: translate(item.pillTextKey),
              buttonText: translate(item.buttonTextKey),
              icon: item.icon,
              accentColor: item.accentColor,
              isButtonOutlined: item.isButtonOutlined,
              onTapButton: () {},
            ),
          )),
          SizedBox(height: 16.h),
          _buildSectionTitle(translate('recent_events'), isDark),
          SizedBox(height: 16.h),
          ..._recentEvents.map((item) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: RecentEventCard(
              icon: item.icon,
              iconColor: item.isPrimaryColor
                  ? AppColors.primary
                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              title: translate(item.titleKey),
              description: translate(item.descriptionKey),
              time: translate(item.timeKey),
            ),
          )),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}
