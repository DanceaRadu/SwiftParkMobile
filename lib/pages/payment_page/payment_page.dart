import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/pages/payment_page/map_view.dart';

import '../../providers/parking_lot_provider.dart';
import '../../models/parking_lot_model.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {

  ParkingLot? selectedParkingLot;

  onParkingLotSelected(ParkingLot parkingLot) {
    setState(() {
      selectedParkingLot = parkingLot;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parkingLotAsyncValue = ref.watch(parkingLotProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
      child: Column(
        children: [
          SizedBox(
            height: 350,
            child: MapView(onMarkerSelected: onParkingLotSelected),
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
          )
        ],
      ),
    );
  }
}
