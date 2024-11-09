import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/widgets/parking_sessions/parking_session_card.dart';
import '../../models/parking_session_params.dart';
import '../../providers/parking_session_provider.dart';

class ParkingSessionList extends ConsumerWidget {
  final dynamic onPay;
  final List<String> licencePlates;
  final String parkingLotId;

  const ParkingSessionList({super.key, required this.onPay, required this.licencePlates, required this.parkingLotId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingSessions = ref.watch(userParkingSessionsProvider(
      ParkingSessionParams(licencePlates, parkingLotId),
    ));

    return parkingSessions.when(
      data: (sessionList) => Column(
        children: sessionList
            .map((session) => ParkingSessionCard(parkingSession: session, onPay: onPay))
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
