import 'package:flutter/material.dart';
import 'package:swift_park/color_palette.dart';
import '../../models/parking_lot_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/prediction_data_point.dart';

class ParkingLotDetail extends StatefulWidget {
  final ParkingLot parkingLot;

  const ParkingLotDetail({super.key, required this.parkingLot});

  @override
  State<ParkingLotDetail> createState() => _ParkingLotDetailState();
}

class _ParkingLotDetailState extends State<ParkingLotDetail> {

  DateTime? _selectedDate;
  List<DataPoint> _dataPoints = [];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: ColorPalette.secondary,
              onPrimary: ColorPalette.onSurface,
              surface: ColorPalette.surface,
              onSurface: ColorPalette.onSurface,
            ),
            dialogBackgroundColor: ColorPalette.surface,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      _makePredictionRequest(pickedDate);
    }
  }

  Future<void> _makePredictionRequest(DateTime pickedDate) async {
    DateTime startDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 8, 0, 0, 258, 849);
    DateTime endDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 17, 0, 0, 258, 894);

    const String url = 'https://parking-prediction.gonemesis.org/predict/interval';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'start': startDateTime.toIso8601String(),
          'end': endDateTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<DataPoint> dataPoints = jsonResponse.entries
            .map((entry) => DataPoint(DateTime.parse(entry.key), entry.value))
            .toList();
        setState(() {
          _dataPoints = dataPoints;
          _selectedDate = pickedDate;
        });
        print("Response data: ${response.body}");
      } else {
        print("Failed to send request. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
    }
  }

  LineChartData _buildChart() {
    return LineChartData(
      minY: 0, // Minimum value for y-axis
      maxY: 1,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              int hour = 8 + value.toInt();
              return Text('$hour:00', style: const TextStyle(fontSize: 10));
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false, // Hide top titles
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            interval: 1,
              showTitles: false
          ),
        ),
      ),
      gridData: const FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: _dataPoints
              .map((dataPoint) => FlSpot(
            dataPoint.timestamp.hour - 8.toDouble(), // X-axis: hours relative to 8 AM
            dataPoint.value, // Y-axis: value from the response
          ))
              .toList(),
          isCurved: true,
          barWidth: 2,
          belowBarData: BarAreaData(show: true),
          dotData: const FlDotData(show: false),
        ),
      ],
    );
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
            const SizedBox(height: 20),
            Expanded(
              child: _dataPoints.isNotEmpty ? LineChart(_buildChart()) : const Text("Please select a date"),
            ),
          ],
        ),
      ),
    );
  }
}
