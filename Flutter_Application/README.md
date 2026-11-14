# SARC

Mobile app for river communities along the Teesta in Sikkim. It shows what satellites picked up around the Singtam–Majitar–Rangpo stretch and explains it in simple words. It does not replace SDMA or the district administration, and the app says so on every screen that could be mistaken for an official source.

Right now this is V1, a frontend demo. Everything you see (advisories, notifications, map layers) is sample data and is marked as such. Please don't show it to anyone as real results.

Built with Flutter, Android only for now.

## Google Maps

The map used to run on OpenStreetMap through flutter_map. I moved it to Google Maps (google_maps_flutter). What changed:

- `lib/screens/map_screen.dart` now uses `GoogleMap` for the polygons, river line and pins. The screen looks and behaves the same as before.
- `pubspec.yaml`: flutter_map is out, google_maps_flutter is in. latlong2 stays because the mock data and models still use its `LatLng`.
- `AndroidManifest.xml`: added the INTERNET permission (it was missing), changed the label to "SARC", and added the Maps API key entry.
- New in the Map screen: a layers button in the top bar to switch between Default, Satellite, Hybrid and Terrain.

Nothing else was touched.

### Adding your API key

1. In Google Cloud Console, enable **Maps SDK for Android** on your project and create an API key.
2. Open `android/app/src/main/AndroidManifest.xml` and replace `YOUR_GOOGLE_MAPS_API_KEY`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

3. Run `flutter clean`, `flutter pub get`, then `flutter run`.

If the map comes up blank grey, check these in order: the SDK is enabled, the key is pasted correctly, and (if you restricted the key) the package name `com.example.sarc` and your SHA-1 match. On an emulator, use an image that has Google Play services.

Don't push the real key to a public repo. Restrict it in the console before you release.

## How the app works

The app opens with a splash screen and then a short introduction, which is only shown the first time (it can be skipped, and replayed from Settings). After that there is a bottom bar with five tabs.

**Home** has a status card, quick links (map, safety guide, report) and the latest two advisories. The bell icon shows the unread count.

**Map** shows the study area (27.1575–27.2025 N, 88.4897–88.5403 E) with the river line and settlement pins. You can switch between Pre-event, Post-event and Change views and toggle Satellite, AOI, River and Settlements on and off. Tapping a pin opens a short note about that settlement. The river line and pins are illustrative, not surveyed, and the satellite shapes are placeholders until real Sentinel-1 / NISAR output is plugged in.

**Advisories** is a list you can filter by information level. A switch hides everything that isn't verified or official. Each advisory opens a detail page with its verification steps.

**Emergency** lists contacts with a Call button that opens the phone dialler.

**More** leads to notification history, the safety guide (before, during and after a river hazard), the report form, About and data, and Settings.

Settings has a notifications switch (preview only in V1), text size, language (English only for now) and a privacy note. The app does not collect location or personal data in V1.

### Information levels

Everything is tagged with one of five levels, so a satellite hint never looks like an official warning:

1. Satellite-observed change: seen in imagery, not a confirmed flood or damage.
2. Algorithm-derived indicator: calculated from satellite data, can be wrong, not checked on the ground.
3. Interpreted potential exposure: the team's reading of what could be exposed. Not a prediction.
4. Independently verified hazard: checked against field reports, gauges or authorities.
5. Official warning: issued by an authorised authority. Always follow this first.

## Code layout

```
lib/
  main.dart, app.dart      startup and theme
  core/                    constants.dart (AOI, texts), theme.dart (colours)
  data/mock_data.dart      all sample data: advisories, contacts, map shapes
  models/models.dart       InfoLevel, Advisory, Settlement, ...
  state/app_state.dart     settings and notification store
  screens/                 one file per screen
  widgets/                 shared cards, badges, banners
assets/images/             logo files
```

Common edits:

- map layers, styles, camera: `lib/screens/map_screen.dart`
- river line, AOI shape, settlements, change patches: `lib/data/mock_data.dart`
- AOI bounds, app texts: `lib/core/constants.dart`
- colours: `lib/core/theme.dart`

## Before a demo or release

- Fill in the blank contacts (Sikkim SDMA, East Sikkim control room) and confirm the numbers marked "Confirm locally" in `mock_data.dart`.
- Keep the SAMPLE labels until real data replaces the mock data.
- Change the application ID from `com.example.sarc` and set up proper release signing (it currently uses the debug key).

## What's next

V2: replace the mock advisories and notifications with Firebase, add push notifications, photo upload in the report form, translations, and saved settings. The screens shouldn't need to change.

V3: swap the placeholder map shapes for real Sentinel-1 / NISAR output, using a `GroundOverlay` for PNG imagery and GeoJSON-built polygons and lines.
