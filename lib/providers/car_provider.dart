import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarNotifier extends StateNotifier<List<Car>> {
  final String userId;

  CarNotifier(this.userId) : super([]) {
    fetchCars();
  }

  // Fetch cars from Firebase for the logged-in user
  Future<void> fetchCars() async {
    final carCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cars');
    final snapshot = await carCollection.get();
    state = snapshot.docs
        .map((doc) => Car.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Add a new car to the user's list
  Future<void> addCar(Car car) async {
    final carCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cars');
    await carCollection.add(car.toJson());
    fetchCars();  // Refresh the list after adding
  }

  // Remove a car from the user's list
  Future<void> removeCar(String carId) async {
    final carDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cars')
        .doc(carId);
    await carDoc.delete();
    fetchCars();  // Refresh the list after removing
  }
}

// Global provider for CarNotifier
final carProvider = StateNotifierProvider.family<CarNotifier, List<Car>, String>(
      (ref, userId) => CarNotifier(userId),
);