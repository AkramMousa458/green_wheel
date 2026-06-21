import 'package:equatable/equatable.dart';

/// Live telemetry parsed from ESP32 SPP line: "V:12.45,I:2.30,T:28.5,SOC:78,F:0"
class BmsReading extends Equatable {
  final double voltage;
  final double current;
  final double temperature;
  final int soc;
  final bool fault;

  const BmsReading({
    required this.voltage,
    required this.current,
    required this.temperature,
    required this.soc,
    required this.fault,
  });

  static BmsReading? tryParse(String raw) {
    final line = raw.trim();
    if (line.isEmpty) return null;

    double? voltage;
    double? current;
    double? temperature;
    int? soc;
    int? fault;

    for (final part in line.split(',')) {
      final segments = part.split(':');
      if (segments.length != 2) continue;

      final key = segments[0].trim().toUpperCase();
      final value = segments[1].trim();

      switch (key) {
        case 'V':
          voltage = double.tryParse(value);
        case 'I':
          current = double.tryParse(value);
        case 'T':
          temperature = double.tryParse(value);
        case 'SOC':
          soc = int.tryParse(value);
        case 'F':
          fault = int.tryParse(value);
      }
    }

    if (voltage == null ||
        current == null ||
        temperature == null ||
        soc == null ||
        fault == null) {
      return null;
    }

    return BmsReading(
      voltage: voltage,
      current: current,
      temperature: temperature,
      soc: soc,
      fault: fault == 1,
    );
  }

  @override
  List<Object?> get props => [voltage, current, temperature, soc, fault];
}
