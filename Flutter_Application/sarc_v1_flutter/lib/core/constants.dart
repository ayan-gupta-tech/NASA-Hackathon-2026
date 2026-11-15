/// App-wide constants. AOI values come from the SARC project brief
/// (candidate bounding box, WGS84 / EPSG:4326 - still to be verified).
class AppConst {
  static const appName = 'SARC';
  static const tagline = 'Satellite insight for river communities';
  static const versionLabel = 'V1 - frontend demo (sample data)';

  // Area of Interest: Singtam-Majitar-Rangpo downstream region
  static const aoiNorth = 27.2025;
  static const aoiSouth = 27.1575;
  static const aoiWest = 88.4897;
  static const aoiEast = 88.5403;
  static const aoiName = 'Singtam - Majitar - Rangpo corridor';

  static const logoFull = 'assets/images/sarc_logo.png';
  static const logoSymbol = 'assets/images/sarc_symbol.png';

  // Shown on every screen that could be mistaken for an official source.
  static const disclaimerShort =
      'SARC complements, and never replaces, official disaster-management '
      'channels. Always follow instructions from Sikkim SDMA and the '
      'district administration.';

  static const sampleDataNotice =
      'V1 DEMO: all advisories, notifications and map layers are sample '
      'content to show how the app will work. They are not real results.';
}
