import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/widgets/parking_sessions/paid_parking_sessions_list.dart';

import '../../providers/car_provider.dart';
import '../../widgets/parking_sessions/parking_session_list.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('No user is logged in.'));
    }
    final carsAsyncValue = ref.watch(userCarsProvider(currentUser.uid));

    return carsAsyncValue.when(
        data: (cars) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: PaidParkingSessionList(
              licencePlates: cars.map((car) => car.licensePlate).toList(),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
    );
  }
}
