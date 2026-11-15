import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          theme: buildSarcTheme(dark: appSettings.isDark),
          // Language: Material widgets (back button, tooltips, pickers) also
          // follow the selected language.
          locale: appSettings.locale,
          supportedLocales: const [Locale('en'), Locale('hi'), Locale('ne')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
