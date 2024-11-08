import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:swift_park/pages/payment_page/map_view.dart';

import '../../providers/parking_lot_provider.dart';
import '../../models/parking_lot_model.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {

  onParkingLotSelected(ParkingLot parkingLot) {
    print('Parking lot selected: ${parkingLot.name}');
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              " Select a parking lot",
              style: TextStyle(
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
