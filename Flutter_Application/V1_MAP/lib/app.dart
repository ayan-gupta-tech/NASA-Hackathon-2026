import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';

class SarcApp extends StatelessWidget {
  const SarcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) {
        return MaterialApp(
          title: 'SARC',
          debugShowCheckedModeBanner: false,
          theme: buildSarcTheme(),
          // Applies the "Text size" setting from the Settings screen everywhere.
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                textScaler: TextScaler.linear(appSettings.textScale),
              ),
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
