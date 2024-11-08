import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../providers/parking_lot_provider.dart';
import '../../models/parking_lot_model.dart';

class MapView extends ConsumerStatefulWidget {

  final Function(ParkingLot) onMarkerSelected;
  const MapView({super.key, required this.onMarkerSelected});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  @override
  Widget build(BuildContext context) {
    final parkingLotAsyncValue = ref.watch(parkingLotProvider);

    return parkingLotAsyncValue.when(
      data: (parkingLots) {
        return FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(45.755826854673785, 21.227471272899766),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.gonemesis.swift_park',
            ),
            MarkerLayer(markers: parkingLots.map((parkingLot) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(parkingLot.latitude, parkingLot.longitude),
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    print('Marker tapped');
                  },
                ),
              );
            }).toList(),)
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
