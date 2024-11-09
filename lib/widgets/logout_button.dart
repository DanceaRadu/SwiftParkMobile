import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color_palette.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ColorPalette.error, width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.exit_to_app,
            color: Color.fromARGB(150, 255, 0, 0),
          ),
          SizedBox(width: 8),
          Text(
            "Logout",
            style: TextStyle(
              color: Color.fromARGB(150, 255, 0, 0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
