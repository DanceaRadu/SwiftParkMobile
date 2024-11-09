import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSession {
  final String? id;
  final String parkingLotId;
  final String designatedParkingSpot;
  final String licensePlate;
  final Timestamp entryTime;
  final Timestamp? exitTime;
  final bool isPaid;

  ParkingSession({
    this.id,
    required this.parkingLotId,
    required this.designatedParkingSpot,
    required this.licensePlate,
    required this.entryTime,
    required this.exitTime,
    required this.isPaid,
  });
}