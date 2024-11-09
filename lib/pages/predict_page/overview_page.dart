import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/pages/parking_lot_detail/parking_lot_detail.dart';

import '../../color_palette.dart';
import '../../providers/parking_lot_provider.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingLotAsyncValue = ref.watch(parkingLotProvider);

    return parkingLotAsyncValue.when(
      data: (parkingLots) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: parkingLots.length,
          itemBuilder: (context, index) {
            final parkingLot = parkingLots[index];
            final occupiedCount = parkingLot.parkingSpots.where((spot) => spot.occupied).length;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingLotDetail(parkingLot: parkingLot),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.darkerSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(parkingLot.name),
                      trailing: Text(
                          '$occupiedCount/${parkingLot.parkingSpots.length} occupied'
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      error: (err, stack) {
        return Center(child: Text('Error: $err'));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
