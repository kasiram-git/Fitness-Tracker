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
    return workouts.isEmpty
        ? const Center(
            child: Text(
              "No workouts logged yet.",
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: workouts.length,
            itemBuilder: (ctx, i) {
              final workout = workouts[i];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date & Core
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${workout.date.toLocal()}".split(' ')[0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            workout.coreMuscle,
                            style: const TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Info rows
                      _infoRow("Duration", "${workout.duration} min", Icons.timer),
                      _infoRow("Calories", "${workout.caloriesBurned} kcal",
                          Icons.local_fire_department),
                      _infoRow("Exercises",
                          workout.exercises.map((e) => e.name).join(", "),
                          Icons.fitness_center),

                      const SizedBox(height: 10),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.amber),
                            onPressed: () => onEdit?.call(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => onDelete?.call(i),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
