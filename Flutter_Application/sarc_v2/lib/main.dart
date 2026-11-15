import 'package:flutter/material.dart';

import 'app.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loads the saved theme and language before the first frame.
  await appSettings.load();
  runApp(const SarcApp());
}
