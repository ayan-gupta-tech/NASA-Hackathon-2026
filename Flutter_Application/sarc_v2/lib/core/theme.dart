import 'package:flutter/material.dart';

/// Brand colours taken from the SARC logo. Change them here to re-theme the app.
///
/// Most colours are getters: they return the light or the dark value
/// depending on [dark], which AppSettings keeps in sync with the theme
/// the user picked (Settings -> Appearance).
class SarcColors {
  /// true while the dark theme is active. Set by AppSettings.
  static bool dark = false;

  static Color _c(int light, int darkValue) => Color(dark ? darkValue : light);

  /// Fixed brand navy (does not change with the theme). Use for fills that
  /// always carry white text, such as the Home status card.
  static const brandNavy = Color(0xFF0B2A5B);

  static Color get navy => _c(0xFF0B2A5B, 0xFFA9CCFF); // headings / accents
  static Color get blue => _c(0xFF0A7BD0, 0xFF5BB0F5);
  static Color get background => _c(0xFFF4F7FB, 0xFF0E1420);
  static Color get card => _c(0xFFFFFFFF, 0xFF18202F);
  static Color get border => _c(0xFFDCE3EE, 0xFF2C3850);
  static Color get textMuted => _c(0xFF5B6B8C, 0xFFA3B0C8);

  // Colours for the five information levels (see InfoLevel in models.dart)
  static Color get satellite => _c(0xFF5B6B8C, 0xFF9AA8C7);
  static Color get derived => _c(0xFF0A7BD0, 0xFF5BB0F5);
  static Color get interpreted => _c(0xFFD98200, 0xFFF2A93B);
  static Color get verified => _c(0xFF1E8E5A, 0xFF4CC38A);
  static Color get official => _c(0xFFC62828, 0xFFFF6B6B);

  // Notice strip (amber), info strip (blue) and danger strip (red)
  static Color get noticeBg => _c(0xFFFFF4DC, 0xFF3A2E12);
  static Color get noticeBorder => _c(0xFFF0C36A, 0xFF7A5F22);
  static Color get noticeText => _c(0xFF6B4500, 0xFFF3D38A);
  static Color get noticeIcon => _c(0xFF8A5A00, 0xFFE9B64F);
  static Color get infoBg => _c(0xFFEAF3FC, 0xFF16283F);
  static Color get dangerBg => _c(0xFFFDECEC, 0xFF3A1A1C);
}

ThemeData buildSarcTheme({required bool dark}) {
  final base = ColorScheme.fromSeed(
    seedColor: SarcColors.brandNavy,
    brightness: dark ? Brightness.dark : Brightness.light,
  );
  final scheme = base.copyWith(
    primary: dark ? const Color(0xFF7DB8F5) : SarcColors.brandNavy,
    onPrimary: dark ? const Color(0xFF0B2A5B) : Colors.white,
    secondary: SarcColors.blue,
    surface: SarcColors.card,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: SarcColors.background,
    dividerColor: SarcColors.border,
    appBarTheme: AppBarTheme(
      backgroundColor: SarcColors.card,
      foregroundColor: SarcColors.navy,
      surfaceTintColor: Colors.transparent,
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
      backgroundColor: SarcColors.card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: SarcColors.blue.withOpacity(0.15),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SarcColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SarcColors.border),
      ),
    ),
  );
}
