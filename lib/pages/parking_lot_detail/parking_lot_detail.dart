import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/parking_lot_model.dart';

class ParkingLotDetail extends StatefulWidget {
  final ParkingLot parkingLot;

  const ParkingLotDetail({super.key, required this.parkingLot});

  @override
  State<ParkingLotDetail> createState() => _ParkingLotDetailState();
}

class _ParkingLotDetailState extends State<ParkingLotDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parkingLot.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Spots: ${widget.parkingLot.parkingSpots.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Available Spots: ${widget.parkingLot.parkingSpots}', // Assuming `availableSpots` is a property in your model
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
