class Car {
  final String? id;
  final String name;
  final String licensePlate;
  final String userId;

  Car({
    this.id,
    required this.name,
    required this.licensePlate,
    required this.userId,
  });

  factory Car.fromJson(Map<String, dynamic> json, String id) {
    return Car(
      id: id,
      name: json['name'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'licensePlate': licensePlate,
      'userId': userId,
    };
  }

  Car copyWith({String? id}) {
    return Car(
      id: id ?? this.id,
      name: name,
      licensePlate: licensePlate,
      userId: userId,
    );
  }
}
