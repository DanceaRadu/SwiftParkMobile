import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_park/color_palette.dart';
import '../../models/parking_lot_model.dart';

class ParkingLotDetail extends StatefulWidget {
  final ParkingLot parkingLot;

  const ParkingLotDetail({super.key, required this.parkingLot});

  @override
  State<ParkingLotDetail> createState() => _ParkingLotDetailState();
}

class _ParkingLotDetailState extends State<ParkingLotDetail> {

  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final occupiedCount =  widget.parkingLot.parkingSpots.where((spot) => spot.occupied).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parkingLot.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Occupied Spots: $occupiedCount/${widget.parkingLot.parkingSpots.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Address: ${widget.parkingLot.address ?? "Not specified"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _pickDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.secondary,
              ),
              child: const Text(
                  'Predict Availability',
                  style: TextStyle(color: ColorPalette.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
