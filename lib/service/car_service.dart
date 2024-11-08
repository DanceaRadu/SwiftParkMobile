import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/car_model.dart';

class CarService {
  final FirebaseFirestore _firestore;

  CarService(this._firestore);

  Stream<List<Car>> getCarsByUserId(String userId) {
    return _firestore
        .collection('cars')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Car.fromJson(doc.data(), doc.id))
        .toList());
  }

  Future<void> addCar(String userId, Car car) async {
    await _firestore.collection('cars').add({
      'userId': userId,
      'licensePlate': car.licensePlate,
      'name': car.name,
    });
  }

  Future<void> deleteCar(String carId) async {
    await _firestore.collection('cars').doc(carId).delete();
  }
}
