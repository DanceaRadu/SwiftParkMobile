import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parking_session_model.dart';
import '../service/parking_session_service.dart';

final parkingSessionServiceProvider = Provider((ref) => ParkingSessionService());

final userParkingSessionsProvider = StreamProvider.autoDispose.family<List<ParkingSession>, List<String>>((ref, licensePlates) {
  final parkingSessionService = ref.watch(parkingSessionServiceProvider);
  return parkingSessionService.getParkingSessionsFromLicensePlates(licensePlates);
});
