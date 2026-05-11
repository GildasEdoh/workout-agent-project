import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/core/theme/app_theme.dart';
import 'package:pose_tracker/providers/settings_provider.dart';
import 'package:pose_tracker/screens/onboarding_screen.dart';
import 'package:pose_tracker/screens/home_screen.dart';

class PoseTrackerApp extends StatelessWidget {
  const PoseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Pose Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.dark, // Enforce dark for this MVP
          home: const OnboardingScreen(),
        );
      },
    );
  }
}
