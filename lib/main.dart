import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:swift_park/pages/auth_pages/auth_page.dart';
import 'package:swift_park/pages/home_page.dart';
import 'color_palette.dart';
import 'firebase_options.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: ColorPalette.seedColor,
  surface: ColorPalette.surface,
  onSurface: ColorPalette.onSurface,
  secondary: ColorPalette.secondary,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    Stripe.publishableKey = 'pk_test_51PATeDRsAXq8UeQDv6ucKJ7odtN1LaifKwrFcjiPiftXrBaJCD5n5PIPKiAH1sxSpv0kh85Lev9LBXoQtmk01bvO00eiwrhhvh';
    Stripe.instance.applySettings();

    return MaterialApp(
      title: 'Swift.park',
      theme: _buildTheme(Brightness.dark),
      darkTheme: _buildTheme(Brightness.dark),
      home: const AuthWrapper(),
      themeMode: ThemeMode.dark,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      colorScheme: kColorScheme,
      scaffoldBackgroundColor: ColorPalette.surface,
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: ColorPalette.surface,
        foregroundColor: ColorPalette.onSurface,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorPalette.onSurface,
        selectedItemColor: ColorPalette.secondary,
        unselectedItemColor: ColorPalette.surface,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorPalette.backgroundColor, // Set default background color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        displayLarge: baseTheme.textTheme.displayLarge?.copyWith(color: Colors.white, letterSpacing: 1.1),
        displayMedium: baseTheme.textTheme.displayMedium?.copyWith(color: Colors.white, letterSpacing: 1.1),
        displaySmall: baseTheme.textTheme.displaySmall?.copyWith(color: Colors.white, letterSpacing: 1.1),
        headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(color: Colors.white, letterSpacing: 1.1),
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(color: Colors.white, letterSpacing: 1.1),
        titleMedium: baseTheme.textTheme.titleMedium?.copyWith(color: Colors.white, letterSpacing: 1.1),
        titleSmall: baseTheme.textTheme.titleSmall?.copyWith(color: Colors.white, letterSpacing: 1.1),
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: Colors.white, letterSpacing: 1.1),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: Colors.white, letterSpacing: 1.1),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(color: Colors.white, letterSpacing: 1.1),
        labelLarge: baseTheme.textTheme.labelLarge?.copyWith(color: Colors.white, letterSpacing: 1.1),
        labelSmall: baseTheme.textTheme.labelSmall?.copyWith(color: Colors.white, letterSpacing: 1.1),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
          fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 2.0, color: Colors.white,
        ),
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage(user: snapshot.data!);
        } else {
          return const AuthPage();
        }
      },
    );
  }
}

