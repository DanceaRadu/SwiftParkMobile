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
    this.exitTime,
    required this.isPaid,
  });

  factory ParkingSession.fromJson(Map<String, dynamic> data, String documentId) {
    return ParkingSession(
      id: documentId,
      parkingLotId: data['parkingLotId'] as String,
      designatedParkingSpot: data['designatedParkingSpot'] as String,
      licensePlate: data['licensePlate'] as String,
      entryTime: data['entryTime'] as Timestamp,
      exitTime: data['exitTime'] != null ? data['exitTime'] as Timestamp : null,
      isPaid: data['isPaid'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parkingLotId': parkingLotId,
      'designatedParkingSpot': designatedParkingSpot,
      'licensePlate': licensePlate,
      'entryTime': entryTime,
      if (exitTime != null) 'exitTime': exitTime,
      'isPaid': isPaid,
    };
  }
}
