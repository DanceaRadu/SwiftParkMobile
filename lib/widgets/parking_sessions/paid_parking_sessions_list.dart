import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/widgets/parking_sessions/parking_session_card.dart';
import '../../providers/parking_session_provider.dart';

class PaidParkingSessionList extends ConsumerWidget {
  final List<String> licencePlates;

  const PaidParkingSessionList({super.key, required this.licencePlates});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingSessions = ref.watch(userPaidParkingSessionsProvider(licencePlates));

    return parkingSessions.when(
      data: (sessionList) => sessionList.isEmpty
          ? const Center(child: Text('No paid parking sessions found.'))
          : Column(
            children: sessionList
                .map((session) => ParkingSessionCard(parkingSession: session, onPay: () {}))
                .toList(),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
