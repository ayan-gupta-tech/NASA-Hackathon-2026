import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import '../core/i18n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pageCount = 3;

  Future<void> _finish() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarded', true);
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            profileStore.hasProfile ? const MainShell() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pageCount - 1;
    return Scaffold(
      backgroundColor: SarcColors.card,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _finish, child: const Tr('Skip')),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: LanguagePicker(),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _IntroPage(
                    icon: Icons.water,
                    title: 'Know your river',
                    body: 'SARC uses radar satellites (Sentinel-1 and NISAR) to '
                        'study the Teesta river corridor around '
                        'Singtam, Majitar and Rangpo, and explains what the '
                        'data may mean in simple language.',
                  ),
                  _LevelsPage(),
                  _IntroPage(
                    icon: Icons.verified_user_outlined,
                    title: 'Official channels come first',
                    body: '${AppConst.disclaimerShort.tr}\n\n'
                        '${'Your location stays on your device unless you choose to share it.'.tr}',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? SarcColors.navy : SarcColors.border,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (isLast) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Tr(isLast ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _IntroPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: SarcColors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: SarcColors.navy),
          ),
          const SizedBox(height: 28),
          Tr(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: SarcColors.navy,
            ),
          ),
          const SizedBox(height: 14),
          Tr(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              color: SarcColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelsPage extends StatelessWidget {
  const _LevelsPage();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        const SizedBox(height: 12),
        Tr(
          'Know what information means',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: SarcColors.navy,
          ),
        ),
        const SizedBox(height: 8),
        Tr(
          'Every item in SARC carries one of these labels.',
          textAlign: TextAlign.center,
          style: TextStyle(color: SarcColors.textMuted),
        ),
        const SizedBox(height: 16),
        for (final level in InfoLevel.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(level.icon, color: level.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tr(
                        level.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: level.color,
                        ),
                      ),
                      Tr(
                        level.description,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: SarcColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
