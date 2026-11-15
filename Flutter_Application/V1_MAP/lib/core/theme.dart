import 'package:flutter/material.dart';

/// Brand colours taken from the SARC logo. Change them here to re-theme the app.
class SarcColors {
  static const navy = Color(0xFF0B2A5B);
  static const blue = Color(0xFF0A7BD0);
  static const background = Color(0xFFF4F7FB);
  static const card = Colors.white;
  static const border = Color(0xFFDCE3EE);
  static const textMuted = Color(0xFF5B6B8C);

  // Colours for the five information levels (see InfoLevel in models.dart)
  static const satellite = Color(0xFF5B6B8C);
  static const derived = Color(0xFF0A7BD0);
  static const interpreted = Color(0xFFD98200);
  static const verified = Color(0xFF1E8E5A);
  static const official = Color(0xFFC62828);
}

ThemeData buildSarcTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: SarcColors.navy,
    primary: SarcColors.navy,
    secondary: SarcColors.blue,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: SarcColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: SarcColors.navy,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: SarcColors.navy,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: SarcColors.blue.withOpacity(0.15),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SarcColors.navy,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SarcColors.border),
      ),
    ),
  );
}
