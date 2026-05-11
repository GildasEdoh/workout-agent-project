import 'package:flutter/material.dart';
import 'package:pose_tracker/models/exercise.dart';
import 'package:pose_tracker/models/workout_history.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Exercise> availableExercises = [
    Exercise(
      id: 'e1',
      name: 'Push-ups',
      description: 'Strengthen your chest, shoulders, and triceps.',
      icon: Icons.fitness_center,
    ),
    Exercise(
      id: 'e2',
      name: 'Squats',
      description: 'Build your leg muscles and core strength.',
      icon: Icons.accessibility_new,
    ),
    Exercise(
      id: 'e3',
      name: 'Jumping Jacks',
      description: 'Full body cardio workout.',
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
