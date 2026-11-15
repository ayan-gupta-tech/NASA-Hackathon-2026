import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _languages = ['English', 'Hindi', 'Nepali'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const SectionHeader('Notifications'),
              SarcCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  title: const Text('Advisory notifications'),
                  subtitle: const Text(
                    'Push notifications are enabled in V2. This switch is a '
                    'preview.',
                  ),
                  value: appSettings.notificationsEnabled,
                  onChanged: (v) => appSettings.notificationsEnabled = v,
                ),
              ),
              const SectionHeader('Display'),
              SarcCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text size (${(appSettings.textScale * 100).round()}%)',
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
                      decoration: const InputDecoration(
                        labelText: 'Language',
                        helperText: 'Translations arrive in V2. English only for now.',
                      ),
                      items: [
                        for (final l in _languages)
                          DropdownMenuItem(value: l, child: Text(l)),
                      ],
                      onChanged: (v) {
                        if (v != null) appSettings.language = v;
                      },
                    ),
                  ],
                ),
              ),
              const SectionHeader('Privacy'),
              const SarcCard(
                child: Text(
                  'SARC does not collect your location in V1. In later '
                  'versions location will stay on your device unless you '
                  'choose to share it, for example when sending a report. '
                  'No personal data is stored in this demo.',
                  style: TextStyle(height: 1.5, color: SarcColors.textMuted),
                ),
              ),
              const SectionHeader('Other'),
              SarcCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.replay),
                  title: const Text('Replay introduction'),
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
