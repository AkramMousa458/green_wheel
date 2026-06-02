import 'package:flutter/material.dart';

/// Describes one telemetry card on the analytics screen.
class TelemetryMetricModel {
  final String titleKey;
  final String value;
  final String unit;
  final IconData icon;
  final List<double> chartData;
  final bool highlightValue;

  const TelemetryMetricModel({
    required this.titleKey,
    required this.value,
    required this.unit,
    required this.icon,
    required this.chartData,
    this.highlightValue = true,
  });
}
