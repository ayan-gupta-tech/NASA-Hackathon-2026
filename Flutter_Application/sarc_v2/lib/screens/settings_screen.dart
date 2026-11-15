import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'onboarding_screen.dart';
import '../core/i18n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _languages = {
    'English': 'English',
    'Hindi': 'हिन्दी',
    'Nepali': 'नेपाली',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Tr('Settings')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const SectionHeader('Appearance'),
              SarcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Tr(
                      'Theme',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Tr('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Tr('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Tr('Dark'),
                          ),
                        ],
                        selected: {appSettings.themeMode},
                        onSelectionChanged: (s) =>
                            appSettings.themeMode = s.first,
                      ),
                    ),
                  ],
                ),
              ),
              const SectionHeader('Display'),
              SarcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tr(
                      '${'Text size'.tr} (${(appSettings.textScale * 100).round()}%)',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Slider(
                      min: 0.9,
                      max: 1.4,
                      divisions: 5,
                      value: appSettings.textScale,
                      onChanged: (v) => appSettings.textScale = v,
                    ),
                    const Divider(height: 24),
                    DropdownButtonFormField<String>(
                      value: appSettings.language,
                      decoration: InputDecoration(
                        labelText: 'Language'.tr,
                        helperText: 'App language'.tr,
                      ),
                      items: [
                        for (final e in _languages.entries)
                          DropdownMenuItem(value: e.key, child: Tr(e.value)),
                      ],
                      onChanged: (v) {
                        if (v != null) appSettings.language = v;
                      },
                    ),
                  ],
                ),
              ),
              const SectionHeader('Privacy'),
              SarcCard(
                child: Tr(
                  'Your name, mobile number, state and district are stored '
                  'only on this device. SARC does not access your live '
                  'location. You can remove your details at any time from '
                  'My profile > Log out.',
                  style: TextStyle(height: 1.5, color: SarcColors.textMuted),
                ),
              ),
              const SectionHeader('Other'),
              SarcCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.replay),
                  title: const Tr('Replay introduction'),
                  onTap: () async {
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarded', false);
                    } catch (_) {}
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const OnboardingScreen(),
                      ),
                      (_) => false,
                    );
                  },
                ),
              ),
              const DisclaimerFooter(),
            ],
          ),
        );
      },
    );
  }
}
