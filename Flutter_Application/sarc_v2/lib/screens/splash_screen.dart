import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';
import '../core/i18n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _next();
  }

  Future<void> _next() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2200)),
      profileStore.load(),
    ]);
    var onboarded = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      onboarded = prefs.getBool('onboarded') ?? false;
    } catch (_) {}
    if (!mounted) return;
    final Widget next = profileStore.hasProfile
        ? const MainShell()
        : (onboarded ? const LoginScreen() : const OnboardingScreen());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SarcColors.dark ? SarcColors.background : Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(SarcColors.dark ? 24 : 0),
                child: Image.asset(
                  AppConst.logoFull,
                  width: 260,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.satellite_alt,
                    size: 96,
                    color: SarcColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Tr(
                AppConst.tagline,
                style: TextStyle(color: SarcColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
