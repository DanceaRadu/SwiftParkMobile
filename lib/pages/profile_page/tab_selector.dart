import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_park/color_palette.dart';

class ProfileTabSelector extends StatelessWidget {
  const ProfileTabSelector({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            onTap(0);
          },
          child: Container(
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedIndex == 0 ? ColorPalette.secondary : ColorPalette.darkerSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car, color: Colors.white),
                SizedBox(height: 4),
                Text("Cars", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onTap(1);
          },
          child: Container(
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedIndex == 1 ? ColorPalette.secondary : ColorPalette.darkerSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.payment, color: Colors.white),
                SizedBox(height: 4),
                Text("Payment", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onTap(2);
          },
          child: Container(
            width: 90,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedIndex == 2 ? ColorPalette.secondary : ColorPalette.darkerSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, color: Colors.white),
                SizedBox(height: 4),
                Text("History", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
