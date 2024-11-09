import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swift_park/color_palette.dart';

import '../../models/parking_session_model.dart';

class ParkingSessionCard extends StatelessWidget {

  final ParkingSession parkingSession;
  final dynamic onPay;

  const ParkingSessionCard({super.key, required this.parkingSession, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.darkerSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          parkingSession.licensePlate,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Spot: ${parkingSession.designatedParkingSpot}",
              style: const TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
            ),
            const SizedBox(height: 4),
            Text(
              "Entry: ${DateFormat('yyyy-MM-dd HH:mm').format(parkingSession.entryTime.toDate())}",
              style: const TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
            ),
            if (parkingSession.exitTime != null) ...[
              const SizedBox(height: 4),
              Text(
                "Exit: ${DateFormat('yyyy-MM-dd HH:mm').format(parkingSession.exitTime!.toDate())}",
                style: const TextStyle(fontSize: 16, color: Colors.white), // Set text color to white
              ),
            ],
            const SizedBox(height: 4),
            Text(
              parkingSession.isPaid ? "Status: Paid" : "Status: Unpaid",
              style: TextStyle(
                fontSize: 16,
                color: parkingSession.isPaid ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: !parkingSession.isPaid
            ? ElevatedButton(
          onPressed: () => onPay(parkingSession),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: ColorPalette.secondary,
          ),
          child: const Text("Pay", style: TextStyle(color: Colors.white)),
        )
            : null,
      ),
    );
  }
}
