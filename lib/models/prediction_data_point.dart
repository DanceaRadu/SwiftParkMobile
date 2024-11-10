class DataPoint {
  final DateTime timestamp;
  final double value;

  DataPoint(this.timestamp, this.value);

  factory DataPoint.fromJson(String timestamp, dynamic value) {
    return DataPoint(DateTime.parse(timestamp), value as double);
  }
}