class Car {
  final String id;
  final String name;
  final String licensePlate;

  Car({
    required this.id,
    required this.name,
    required this.licensePlate,
  });

  factory Car.fromJson(Map<String, dynamic> json, String id) {
    return Car(
      id: id,
      name: json['name'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'licensePlate': licensePlate,
    };
  }
}
