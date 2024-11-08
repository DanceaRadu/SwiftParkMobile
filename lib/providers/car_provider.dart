import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';
import '../service/car_service.dart';

// Provider to create an instance of CarService
final carServiceProvider = Provider<CarService>((ref) {
  return CarService(FirebaseFirestore.instance);
});

// StreamProvider to fetch the list of cars for a user in real-time
final userCarsProvider = StreamProvider.autoDispose.family<List<Car>, String>((ref, userId) {
  final carService = ref.watch(carServiceProvider);
  return carService.getCarsByUserId(userId);
});

// Provider to handle adding a car
final addCarProvider = Provider((ref) {
  final carService = ref.watch(carServiceProvider);
  return (String userId, Car car) async {
    await carService.addCar(userId, car);
  };
});

// Provider to handle deleting a car
final deleteCarProvider = Provider((ref) {
  final carService = ref.watch(carServiceProvider);
  return (String carId) async {
    await carService.deleteCar(carId);
  };
});
