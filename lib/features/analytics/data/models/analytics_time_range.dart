/// Time window options for the analytics charts.
enum AnalyticsTimeRange {
  oneHour('time_range_1h'),
  sixHours('time_range_6h'),
  twentyFourHours('time_range_24h'),
  sevenDays('time_range_7d');

  const AnalyticsTimeRange(this.labelKey);

  final String labelKey;
}
