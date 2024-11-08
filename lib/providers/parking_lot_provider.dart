import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parking_lot_model.dart';
import '../service/parking_lot_service.dart';

final parkingLotServiceProvider = Provider((ref) => ParkingLotService());

final parkingLotProvider = StreamProvider<List<ParkingLot>>((ref) {
  final parkingLotService = ref.watch(parkingLotServiceProvider);
  return parkingLotService.getParkingLotsStream();
});