class ParkingSpot {
  final String designation;
  final int level;
  final bool occupied;

  ParkingSpot({
    required this.designation,
    required this.level,
    required this.occupied,
  });

  factory ParkingSpot.fromMap(Map<String, dynamic> data) {
    return ParkingSpot(
      designation: data['designation'] as String,
      level: data['level'] as int,
      occupied: data['occupied'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'designation': designation,
      'level': level,
      'occupied': occupied,
    };
  }
}
