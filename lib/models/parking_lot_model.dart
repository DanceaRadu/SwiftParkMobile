class ParkingLot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double? price;

  ParkingLot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.price,
  });

  factory ParkingLot.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ParkingLot(
      id: documentId,
      name: data['name'] as String,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      price: data['price'] != null ? (data['price'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (price != null) 'price': price,
    };
  }
}
