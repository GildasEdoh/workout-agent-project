class WorkoutHistory {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final int reps;
  final int durationSeconds;
  final DateTime date;
  final int score;

  WorkoutHistory({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.reps,
    required this.durationSeconds,
    required this.date,
    required this.score,
  });
}
