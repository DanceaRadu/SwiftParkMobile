import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_lot_model.dart';

class ParkingLotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ParkingLot>> getParkingLotsStream() {
    return _firestore.collection('parking_lots').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingLot.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
