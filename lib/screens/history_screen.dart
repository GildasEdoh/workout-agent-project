import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pose_tracker/providers/workout_provider.dart';
import 'package:pose_tracker/core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<WorkoutProvider>(context).history.reversed.toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Activity History',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            // Placeholder for a chart
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Chart Placeholder\n(Weekly Progress)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Workouts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Text(
                        'No workouts yet.\nStart sweating!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final workout = history[index];
                        final timeAgo = _formatDate(workout.date);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_circle_outline, color: AppColors.primary),
                            ),
                            title: Text(workout.exerciseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(timeAgo, style: const TextStyle(color: AppColors.textSecondary)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${workout.reps} Reps', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Score: ${workout.score}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }
}
