import 'package:flutter/material.dart';
import 'package:pose_tracker/models/exercise.dart';
import 'package:pose_tracker/models/workout_history.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Exercise> availableExercises = [
    Exercise(
      id: 'e1',
      name: 'Push-ups',
      description: 'Strengthen your chest, shoulders, and triceps.',
      difficulty: 'Beginner',
      instructions: [
        'Place your hands shoulder-width apart.',
        'Keep your back straight and core engaged.',
        'Lower your body until your chest nearly touches the floor.',
        'Push yourself back up to the starting position.'
      ],
      musclesTargeted: ['Chest', 'Shoulders', 'Triceps'],
      icon: Icons.fitness_center,
    ),
    Exercise(
      id: 'e2',
      name: 'Squats',
      description: 'Build your leg muscles and core strength.',
      difficulty: 'Intermediate',
      instructions: [
        'Stand with feet slightly wider than hip-width apart.',
        'Keep your chest up and back straight.',
        'Lower your hips back and down as if sitting in a chair.',
        'Return to the standing position by pushing through your heels.'
      ],
      musclesTargeted: ['Quads', 'Glutes', 'Hamstrings', 'Core'],
      icon: Icons.accessibility_new,
    ),
    Exercise(
      id: 'e3',
      name: 'Jumping Jacks',
      description: 'Full body cardio workout.',
      difficulty: 'Beginner',
      instructions: [
        'Stand with feet together and arms at your sides.',
        'Jump and spread your legs while swinging arms overhead.',
        'Jump back to the starting position.',
        'Maintain a steady rhythm.'
      ],
      musclesTargeted: ['Full Body', 'Cardio'],
      icon: Icons.sports_gymnastics,
    ),
  ];

  final List<WorkoutHistory> _history = [];
  List<WorkoutHistory> get history => [..._history];

  int get totalWorkouts => _history.length;
  int get totalReps => _history.fold(0, (sum, item) => sum + item.reps);

  void addWorkoutResult(WorkoutHistory result) {
    _history.add(result);
    notifyListeners();
  }
}
