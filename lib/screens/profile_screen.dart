import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/providers/settings_provider.dart';
import 'package:pose_tracker/providers/workout_provider.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';
import 'package:pose_tracker/widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final workoutStats = Provider.of<WorkoutProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe', style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 4),
                    Text('Fitness Enthusiast', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                StatCard(title: 'Workouts', value: workoutStats.totalWorkouts.toString(), icon: Icons.fitness_center),
                const SizedBox(width: 16),
                StatCard(title: 'Total Reps', value: workoutStats.totalReps.toString(), icon: Icons.repeat),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    subtitle: const Text('Workout sounds and beeps'),
                    value: settings.soundEnabled,
                    onChanged: (val) => settings.toggleSound(),
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1, color: AppColors.surfaceHighlight),
                  SwitchListTile(
                    title: const Text('Voice Feedback'),
                    subtitle: const Text('AI coach real-time feedback'),
                    value: settings.voiceFeedbackEnabled,
                    onChanged: (val) => settings.toggleVoiceFeedback(),
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1, color: AppColors.surfaceHighlight),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('App appearance'),
                    value: settings.darkMode,
                    onChanged: (val) => settings.toggleDarkMode(),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
