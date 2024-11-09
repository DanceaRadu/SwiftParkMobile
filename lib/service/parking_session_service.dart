import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swift_park/models/parking_session_model.dart';
import 'package:swift_park/models/parking_session_params.dart';

class ParkingSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ParkingSessionService();

  Stream<List<ParkingSession>> getParkingSessionsFromLicensePlates(ParkingSessionParams params) {
    return _firestore
        .collection('parking_sessions')
        .where('licensePlate', whereIn: params.licensePlates)
        .where('parkingLotId', isEqualTo: params.parkingLotId)
        .where('isPaid', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ParkingSession.fromJson(doc.data(), doc.id))
        .toList());
  }
}
