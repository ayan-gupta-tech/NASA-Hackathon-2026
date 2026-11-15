import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

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
    await Future.delayed(const Duration(milliseconds: 2200));
    var onboarded = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      onboarded = prefs.getBool('onboarded') ?? false;
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            onboarded ? const MainShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) =>
              Opacity(opacity: value, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppConst.logoFull,
                width: 260,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.satellite_alt,
                  size: 96,
                  color: SarcColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
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
