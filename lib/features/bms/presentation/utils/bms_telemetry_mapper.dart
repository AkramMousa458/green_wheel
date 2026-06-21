import 'package:flutter/material.dart';
import 'package:green_wheel/features/analytics/data/models/telemetry_metric_model.dart';
import 'package:green_wheel/features/bms/cubit/bms_state.dart';
import 'package:green_wheel/features/bms/data/models/bms_reading.dart';

/// Maps live BMS state into values used by Home, Analytics, and Alerts screens.
class BmsTelemetryMapper {
  BmsTelemetryMapper._();

  static bool isConnected(BmsState state) =>
      state.status == BmsStatus.connected;

  static BmsReading? reading(BmsState state) => state.latestReading;

  static String formatVoltage(BmsReading? reading, {bool connected = false}) {
    if (!connected || reading == null) return '--';
    return '${reading.voltage.toStringAsFixed(2)}V';
  }

  static String formatCurrent(BmsReading? reading, {bool connected = false}) {
    if (!connected || reading == null) return '--';
    return '${reading.current.toStringAsFixed(2)}A';
  }

  static String formatTemperature(BmsReading? reading, {bool connected = false}) {
    if (!connected || reading == null) return '--';
    return '${reading.temperature.toStringAsFixed(1)}°C';
  }

  static double socPercentage(BmsState state) {
    if (!isConnected(state) || state.latestReading == null) return 0;
    return state.latestReading!.soc.toDouble();
  }

  static String temperatureStatusKey(
    BmsReading? reading, {
    bool connected = false,
  }) {
    if (!connected || reading == null) return 'offline';
    if (reading.fault || reading.temperature >= 55) return 'critical';
    if (reading.temperature >= 45) return 'high';
    return 'optimal';
  }

  static List<TelemetryMetricModel> analyticsMetrics(BmsState state) {
    final live = reading(state);
    final connected = isConnected(state);
    final history = state.history;

    List<double> series(double Function(BmsReading r) selector) {
      if (history.length >= 2) {
        return history.map(selector).toList();
      }
      if (live != null) return [selector(live), selector(live)];
      return const [0, 0];
    }

    return [
      TelemetryMetricModel(
        titleKey: 'pack_voltage',
        value: connected && live != null
            ? live.voltage.toStringAsFixed(1)
            : '--',
        unit: 'V',
        icon: Icons.bolt_rounded,
        chartData: series((r) => r.voltage),
      ),
      TelemetryMetricModel(
        titleKey: 'discharge_current',
        value: connected && live != null
            ? live.current.toStringAsFixed(1)
            : '--',
        unit: 'A',
        icon: Icons.speed_rounded,
        chartData: series((r) => r.current),
      ),
      TelemetryMetricModel(
        titleKey: 'cell_temperature',
        value: connected && live != null
            ? live.temperature.toStringAsFixed(1)
            : '--',
        unit: '°C',
        icon: Icons.thermostat_rounded,
        chartData: series((r) => r.temperature),
        highlightValue: false,
      ),
    ];
  }
}
