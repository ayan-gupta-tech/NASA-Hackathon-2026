/// App-wide constants. AOI values come from the SARC project brief
/// (WGS84 / EPSG:4326).
class AppConst {
  static const appName = 'SARC';
  static const tagline = 'Satellite insight for river communities';
  static const versionLabel = 'Version 1.0.0';

  // Area of Interest: Singtam-Majitar-Rangpo downstream region
  static const aoiNorth = 27.2025;
  static const aoiSouth = 27.1575;
  static const aoiWest = 88.4897;
  static const aoiEast = 88.5403;
  static const aoiName = 'Singtam - Majitar - Rangpo corridor';

  static const logoFull = 'assets/images/sarc_logo.png';
  static const logoSymbol = 'assets/images/sarc_symbol.png';

  // Shown on screens that could be mistaken for an official source.
  static const disclaimerShort =
      'SARC complements, and never replaces, official disaster-management '
      'channels. Always follow instructions from Sikkim SDMA and the '
      'district administration.';
}
