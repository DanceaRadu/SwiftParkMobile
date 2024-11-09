class ParkingSpot {
  final String designation;
  final int level;

  ParkingSpot({
    required this.designation,
    required this.level,
  });

  factory ParkingSpot.fromMap(Map<String, dynamic> data) {
    return ParkingSpot(
      designation: data['designation'] as String,
      level: data['floor'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'designation': designation,
      'level': level,
    };
  }
}
