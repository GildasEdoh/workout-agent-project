import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/providers/workout_provider.dart';
import 'package:pose_tracker/widgets/exercise_card.dart';
import 'package:pose_tracker/screens/camera_workout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final exercises = workoutProvider.availableExercises;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Good morning,',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[400],
                  ),
            ),
            Text(
              'Ready to Sweat?',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32),
            Text(
              'Today\'s Exercises',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ExerciseCard(
                    exercise: exercise,
                    onStart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraWorkoutScreen(exercise: exercise),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
