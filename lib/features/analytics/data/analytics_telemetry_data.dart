import 'package:flutter/material.dart';
import 'package:green_wheel/features/analytics/data/models/telemetry_metric_model.dart';

/// Mock telemetry values and chart samples.
/// Edit this file when wiring real API data.
class AnalyticsTelemetryData {
  AnalyticsTelemetryData._();

  static const List<TelemetryMetricModel> metrics = [
    TelemetryMetricModel(
      titleKey: 'pack_voltage',
      value: '398.2',
      unit: 'V',
      icon: Icons.bolt_rounded,
      chartData: [0.35, 0.42, 0.38, 0.55, 0.48, 0.62, 0.58, 0.72, 0.68, 0.85],
    ),
    TelemetryMetricModel(
      titleKey: 'discharge_current',
      value: '42.5',
      unit: 'A',
      icon: Icons.speed_rounded,
      chartData: [0.2, 0.85, 0.35, 0.9, 0.4, 0.75, 0.3, 0.95, 0.5, 0.65],
    ),
    TelemetryMetricModel(
      titleKey: 'cell_temperature',
      value: '28.4',
      unit: '°C',
      icon: Icons.thermostat_rounded,
      chartData: [0.52, 0.54, 0.53, 0.55, 0.54, 0.56, 0.55, 0.54, 0.55, 0.56],
      highlightValue: false,
    ),
  ];
}
