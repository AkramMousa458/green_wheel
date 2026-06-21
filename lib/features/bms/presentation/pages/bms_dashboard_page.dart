import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/bms/cubit/bms_cubit.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/presentation/widgets/bms_gauge_card.dart';
import 'package:green_wheel/features/bms/presentation/widgets/bms_live_chart.dart';

class BmsDashboardPage extends StatelessWidget {
  const BmsDashboardPage({super.key});

  static const String routeName = '/bms-dashboard';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await context.read<BmsCubit>().disconnect();
        if (context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Dashboard'),
          backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
          foregroundColor:
              isDark ? AppColors.white : AppColors.lightTextPrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await context.read<BmsCubit>().disconnect();
              if (context.mounted) context.pop();
            },
          ),
        ),
        body: BlocBuilder<BmsCubit, BmsState>(
          builder: (context, state) {
            final reading = state.latestReading;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {},
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                children: [
                  if (state.connectedDevice != null)
                    Text(
                      'Connected: ${state.connectedDevice!.name ?? state.connectedDevice!.address}',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontSize: 13.sp,
                      ),
                    ),
                  if (state.connectedDevice != null) SizedBox(height: 16.h),
                  BmsGaugeCard(reading: reading),
                  SizedBox(height: 16.h),
                  _MetricRow(
                    label: 'Voltage',
                    value: reading != null ? '${reading.voltage.toStringAsFixed(2)} V' : '--',
                    icon: Icons.bolt_rounded,
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _MetricRow(
                    label: 'Current',
                    value: reading != null ? '${reading.current.toStringAsFixed(2)} A' : '--',
                    icon: Icons.speed_rounded,
                    isDark: isDark,
                  ),
                  SizedBox(height: 12.h),
                  _MetricRow(
                    label: 'Temperature',
                    value: reading != null ? '${reading.temperature.toStringAsFixed(1)} °C' : '--',
                    icon: Icons.thermostat_rounded,
                    isDark: isDark,
                  ),
                  SizedBox(height: 20.h),
                  BmsLiveChart(
                    history: state.history,
                    title: 'Voltage (live)',
                    lineColor: AppColors.primary,
                    valueSelector: (r) => r.voltage,
                  ),
                  SizedBox(height: 16.h),
                  BmsLiveChart(
                    history: state.history,
                    title: 'Current (live)',
                    lineColor: AppColors.secondary,
                    valueSelector: (r) => r.current,
                  ),
                  SizedBox(height: 16.h),
                  BmsLiveChart(
                    history: state.history,
                    title: 'SOC (live)',
                    lineColor: AppColors.success500,
                    valueSelector: (r) => r.soc.toDouble(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.white : AppColors.lightTextPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
