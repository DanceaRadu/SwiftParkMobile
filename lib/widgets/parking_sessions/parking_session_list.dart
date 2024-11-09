import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/widgets/parking_sessions/unpaid_parking_session_card.dart';
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
      data: (sessionList) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessionList.length,
        itemBuilder: (context, index) {
          final session = sessionList[index];
          return UnpaidParkingSessionCard(parkingSession: session, onPay: onPay);
        },
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
