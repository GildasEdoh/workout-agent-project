import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';
import 'package:pose_tracker/models/exercise.dart';
import 'package:pose_tracker/models/workout_history.dart';
import 'package:pose_tracker/providers/workout_provider.dart';
import 'package:pose_tracker/widgets/primary_button.dart';
import 'package:pose_tracker/widgets/stat_card.dart';

class ResultScreen extends StatefulWidget {
  final Exercise exercise;
  final int reps;
  final int durationSeconds;

  const ResultScreen({
    super.key,
    required this.exercise,
    required this.reps,
    required this.durationSeconds,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Save to history on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final score = (widget.reps * 10) + (100 - widget.durationSeconds).clamp(0, 100);
      Provider.of<WorkoutProvider>(context, listen: false).addWorkoutResult(
        WorkoutHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          exerciseId: widget.exercise.id,
          exerciseName: widget.exercise.name,
          reps: widget.reps,
          durationSeconds: widget.durationSeconds,
          date: DateTime.now(),
          score: score,
        ),
      );
    });
  }

  String _formatTime() {
    final m = widget.durationSeconds ~/ 60;
    final s = widget.durationSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Complete'),
        automaticallyImplyLeading: false, // Prevent back button
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: AppColors.warning),
              const SizedBox(height: 24),
              Text(
                'Great Job!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'You just finished ${widget.exercise.name}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatCard(title: 'Reps', value: widget.reps.toString(), icon: Icons.repeat),
                  const SizedBox(width: 16),
                  StatCard(title: 'Time', value: _formatTime(), icon: Icons.timer),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.pop(context); // Go back to Home
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Try Again', style: TextStyle(color: AppColors.secondary, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
