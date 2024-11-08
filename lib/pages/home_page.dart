import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_park/pages/payment_page/payment_page.dart';
import 'package:swift_park/pages/predict_page/predict_page.dart';
import 'package:swift_park/pages/profile_page/profile_page.dart';

import '../color_palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = const PaymentPage();
    var activePageTitle = "Home";
    if(_selectedPageIndex == 1) {
      activePage = const PredictPage();
      activePageTitle = "Predictions";
    }
    if(_selectedPageIndex == 2) {
      activePage = const ProfilePage();
      activePageTitle = "Profile";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: _selectedPageIndex == 2 ? ColorPalette.darkerSurface : ColorPalette.surface,
      ),
      body: activePage,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph_outlined), label: "Predict"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
      ),
    );
  }
}