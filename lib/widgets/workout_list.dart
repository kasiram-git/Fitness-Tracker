import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  final void Function(int index)? onEdit;
  final void Function(int index)? onDelete;

  const WorkoutList({
    super.key,
    required this.workouts,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (ctx, i) {
        final workout = workouts[i];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              "${workout.date.toLocal()}".split(' ')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Core: ${workout.coreMuscle}\nDuration: ${workout.duration} min | Calories: ${workout.caloriesBurned} kcal\nExercises: ${workout.exercises.map((e) => e.name).join(', ')}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEdit?.call(i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete?.call(i),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
