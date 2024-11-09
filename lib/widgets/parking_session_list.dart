import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/parking_session_model.dart';
import '../providers/parking_session_provider.dart';

class ParkingSessionList extends ConsumerWidget {

  final dynamic onPay;
  final List<String> licencePlates;

  const ParkingSessionList({super.key, required this.onPay, required this.licencePlates});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final parkingSessions = ref.watch(userParkingSessionsProvider(licencePlates));

    return parkingSessions.when(
      data: (sessionList) =>
        ListView.builder(
          itemCount: sessionList.length,
          itemBuilder: (context, index) {
            final session = sessionList[index];
            return Text(session.licensePlate);
          },
        ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
