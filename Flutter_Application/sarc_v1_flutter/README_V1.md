# SARC V1 - Flutter frontend (sample data)

## How to add this to your Android Studio project
1. Delete the default `lib/main.dart` and `test/widget_test.dart` in your project (the test refers to `MyApp` and will not compile).
2. Copy the `lib/` folder from this zip into your project (it replaces your `lib/`).
3. Copy `assets/` into your project root.
4. Merge `pubspec.yaml`: keep your own `name:`, add the 4 dependencies (flutter_map, latlong2, url_launcher, shared_preferences) and the `assets: - assets/images/` entry. Then run `flutter pub get`.
5. Icons: copy `android_icons/app/src/main/res/*` into `android/app/src/main/res/` (merge, replace).
6. Edit `android/app/src/main/AndroidManifest.xml`:
   - Inside `<manifest>` (above `<application>`), add:
       <uses-permission android:name="android.permission.INTERNET"/>
       <queries>
         <intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent>
       </queries>
   - In `<application ...>` set: android:label="SARC"  android:icon="@mipmap/ic_launcher"  android:roundIcon="@mipmap/ic_launcher_round"
   (INTERNET is needed for the map tiles in release builds; the call buttons need the `tel` query.)
7. `flutter clean`, uninstall the old app from the emulator, `flutter run`.

## Where to edit things (one file per screen)
| Screen | File |
|---|---|
| Splash | lib/screens/splash_screen.dart |
| Onboarding | lib/screens/onboarding_screen.dart |
| Bottom navigation | lib/screens/main_shell.dart |
| Home | lib/screens/home_screen.dart |
| Map | lib/screens/map_screen.dart |
| Advisories list / detail | lib/screens/advisories_screen.dart, advisory_detail_screen.dart |
| Notification history | lib/screens/notifications_screen.dart |
| Safety guide | lib/screens/safety_guide_screen.dart |
| Emergency contacts | lib/screens/emergency_screen.dart |
| Report observation | lib/screens/report_screen.dart |
| About and data | lib/screens/about_data_screen.dart |
| Settings | lib/screens/settings_screen.dart |
| More menu | lib/screens/more_screen.dart |
| Colours / theme | lib/core/theme.dart |
| AOI, texts | lib/core/constants.dart |
| ALL sample data (advisories, contacts, map shapes) | lib/data/mock_data.dart |
| Shared widgets (cards, badges, legend) | lib/widgets/common_widgets.dart |

## Before you demo / release
- Fill the blank contacts (Sikkim SDMA, East Sikkim control room) and confirm the numbers marked "Confirm locally" in `mock_data.dart`.
- River line and settlement pins are illustrative, not surveyed.
- Sample advisories are labelled SAMPLE on purpose. Do not present them as real results.

## Next versions
- V2: replace `MockData.advisories/notifications` with Firebase; keep screens unchanged.
- V3: in `map_screen.dart` swap the placeholder polygons for `OverlayImageLayer` (PNG + bounds) and GeoJSON layers from Shrujal/Alfaz.
