import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/active_priority_card.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/attention_card.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/recent_event_card.dart';
import 'package:green_wheel/features/alerts/data/models/alert_models.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';
import 'package:green_wheel/features/bms/presentation/utils/bms_telemetry_mapper.dart';

class AlertsScreenBody extends StatelessWidget {
  const AlertsScreenBody({super.key});

  List<ActivePriorityModel> _liveAlerts(BmsReading? reading) {
    if (reading == null) return const [];

    final alerts = <ActivePriorityModel>[];

    if (reading.fault) {
      alerts.add(
        const ActivePriorityModel(
          titleKey: 'bms_fault_detected',
          descriptionKey: 'bms_fault_desc',
          pillTextKey: 'critical',
          buttonTextKey: 'initiate_diagnostics',
          icon: Icons.error_outline_rounded,
          accentColor: AppColors.error,
          isButtonOutlined: false,
        ),
      );
    }

    if (reading.temperature >= 45) {
      alerts.add(
        const ActivePriorityModel(
          titleKey: 'battery_high_temp',
          descriptionKey: 'battery_high_temp_desc',
          pillTextKey: 'critical',
          buttonTextKey: 'initiate_diagnostics',
          icon: Icons.thermostat_outlined,
          accentColor: Color(0xFFF08080),
          isButtonOutlined: false,
        ),
      );
    }

    if (reading.soc < 20) {
      alerts.add(
        const ActivePriorityModel(
          titleKey: 'bms_low_soc',
          descriptionKey: 'bms_low_soc_desc',
          pillTextKey: 'warning',
          buttonTextKey: 'find_charger',
          icon: Icons.battery_alert_outlined,
          accentColor: AppColors.primary,
          isButtonOutlined: true,
        ),
      );
    }

    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return BlocBuilder<BmsCubit, BmsState>(
      builder: (context, state) {
        final connected = BmsTelemetryMapper.isConnected(state);
        final reading = BmsTelemetryMapper.reading(state);
        final activeAlerts = connected ? _liveAlerts(reading) : const <ActivePriorityModel>[];

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
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              if (!connected)
                AttentionCard(
                  title: translate('offline'),
                  description: translate('waiting_for_connection'),
                )
              else if (activeAlerts.isEmpty)
                AttentionCard(
                  title: translate('all_clear'),
                  description: translate('all_clear_desc'),
                )
              else
                AttentionCard(
                  title: translate('attention_required'),
                  description: translate('attention_required_desc'),
                ),
              SizedBox(height: 32.h),
              _buildSectionTitle(translate('active_priority'), isDark),
              SizedBox(height: 16.h),
              if (activeAlerts.isEmpty)
                Text(
                  connected
                      ? translate('all_clear_desc')
                      : translate('waiting_for_connection'),
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 14.sp,
                  ),
                )
              else
                ...activeAlerts.map(
                  (item) => Padding(
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
                  ),
                ),
              if (connected && state.errorMessage != null) ...[
                SizedBox(height: 16.h),
                _buildSectionTitle(translate('recent_events'), isDark),
                SizedBox(height: 16.h),
                RecentEventCard(
                  icon: Icons.wifi_off_rounded,
                  iconColor: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  title: translate('connection_dropped'),
                  description: state.errorMessage!,
                  time: translate('time_10_42'),
                ),
              ],
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
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
