import 'package:swift_park/models/parking_spot_model.dart';

class ParkingLot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double? price;
  final String? address;
  final List<ParkingSpot> parkingSpots;

  ParkingLot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.price,
    this.address,
    required this.parkingSpots,
  });

  factory ParkingLot.fromFirestore(Map<String, dynamic> data, String documentId) {
    print(data['name']);
    return ParkingLot(
      id: documentId,
      name: data['name'] as String,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
      address: data['address'] != null ? data['address'] as String : null,
      price: data['price'] != null ? (data['price'] as num).toDouble() : null,
      parkingSpots: data['parkingSpots'] != null
          ? (data['parkingSpots'] as List)
          .map((spot) => ParkingSpot.fromMap(spot as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      if (price != null) 'price': price,
      'parkingSpots': parkingSpots.map((spot) => spot.toMap()).toList(),
    };
  }
}
