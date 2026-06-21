import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/presentation/utils/bms_telemetry_mapper.dart';
import 'package:green_wheel/features/home/presentation/widgets/battery_indicator.dart';
import 'package:green_wheel/features/home/presentation/widgets/metric_card.dart';
import 'package:green_wheel/features/home/presentation/widgets/status_card.dart';
import 'package:green_wheel/features/home/presentation/widgets/temperature_card.dart';

import 'package:flutter_translate/flutter_translate.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BmsCubit, BmsState>(
      builder: (context, state) {
        final connected = BmsTelemetryMapper.isConnected(state);
        final reading = BmsTelemetryMapper.reading(state);
        final tempStatusKey = BmsTelemetryMapper.temperatureStatusKey(
          reading,
          connected: connected,
        );
        final tempStatus = tempStatusKey == 'offline'
            ? translate('offline')
            : translate(tempStatusKey);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              StatusCard(
                connected: connected,
                hasFault: reading?.fault ?? false,
              ),
              SizedBox(height: 40.h),
              BatteryIndicator(
                percentage: BmsTelemetryMapper.socPercentage(state),
                showPlaceholder: !connected || reading == null,
              ),
              SizedBox(height: 40.h),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: translate('voltage'),
                      value: BmsTelemetryMapper.formatVoltage(
                        reading,
                        connected: connected,
                      ),
                      icon: Icons.bolt_rounded,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: MetricCard(
                      title: translate('current'),
                      value: BmsTelemetryMapper.formatCurrent(
                        reading,
                        connected: connected,
                      ),
                      icon: Icons.speed_rounded,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TemperatureCard(
                temperature: BmsTelemetryMapper.formatTemperature(
                  reading,
                  connected: connected,
                ),
                status: tempStatus,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
