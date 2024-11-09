import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/pages/payment_page/map_view.dart';
import 'package:swift_park/providers/parking_session_provider.dart';
import 'package:swift_park/widgets/parking_session_list.dart';

import '../../models/car_model.dart';
import '../../models/parking_session_model.dart';
import '../../providers/car_provider.dart';
import '../../providers/parking_lot_provider.dart';
import '../../models/parking_lot_model.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {

  ParkingLot? selectedParkingLot;

  onParkingLotSelected(ParkingLot parkingLot, List<Car> cars) {
    setState(() {
      selectedParkingLot = parkingLot;
    });
  }

  onPayForParkingSession(ParkingSession parkingSession) {
    // Implement payment logic here
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('No user is logged in.'));
    }

    final carsAsyncValue = ref.watch(userCarsProvider(currentUser.uid));
    final parkingLotAsyncValue = ref.watch(parkingLotProvider);

    return carsAsyncValue.when(
      data: (cars) =>  Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
        child: Column(
          children: [
            SizedBox(
                height: 350,
                child: MapView(onMarkerSelected: (lot) => {
                  onParkingLotSelected(lot, cars)
                }),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                selectedParkingLot != null
                    ? selectedParkingLot!.name
                    : "Select a parking lot",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: ParkingSessionList(onPay: () {}, licencePlates: cars.map((car) => car.licensePlate).toList()) ),
          ],
        ),
      ),
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
