import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swift_park/models/parking_session_model.dart';

class ParkingSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ParkingSessionService();

  Stream<List<ParkingSession>> getParkingSessionsFromLicensePlates(List<String> licensePlates) {
    return _firestore
        .collection('parking_sessions')
        //.where('licensePlate', whereIn: licensePlates)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ParkingSession.fromJson(doc.data(), doc.id))
        .toList());
  }
}
