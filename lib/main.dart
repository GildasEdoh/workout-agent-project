import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/providers/workout_provider.dart';
import 'package:pose_tracker/providers/settings_provider.dart';
import 'package:pose_tracker/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const PoseTrackerApp(),
    ),
  );
}
