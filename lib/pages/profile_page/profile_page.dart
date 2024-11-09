import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_park/pages/profile_page/cars.dart';
import 'package:swift_park/pages/profile_page/history_tab.dart';
import 'package:swift_park/pages/profile_page/profile_info.dart';
import 'package:swift_park/pages/profile_page/tab_selector.dart';
import 'package:swift_park/widgets/logout_button.dart';

import '../../color_palette.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getWidget() {
    switch (selectedIndex) {
      case 0:
        return const Cars();
      case 1:
        return const Text("------");
      default:
        return const HistoryTab();
    }
  }

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    Widget renderedTab = getWidget();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: double.infinity),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                      color: ColorPalette.darkerSurface,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ProfileInfo(user: user)
                ),
                const SizedBox(height: 32),
                ProfileTabSelector(selectedIndex: selectedIndex, onTap: onTap),
                const SizedBox(height: 16),
                renderedTab,
                const SizedBox(height: 30),
                const LogoutButton(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}