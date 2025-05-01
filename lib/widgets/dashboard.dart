import 'package:flutter/material.dart';
import '../models/workout.dart';

class Dashboard extends StatelessWidget {
  final List<Workout> workouts;

  const Dashboard({super.key, required this.workouts});

  @override
  Widget build(BuildContext context) {
    final totalWorkouts = workouts.length;
    final totalCalories =
        workouts.fold<int>(0, (sum, w) => sum + w.caloriesBurned);
    final totalDuration =
        workouts.fold<int>(0, (sum, w) => sum + w.duration);
    final lastWorkout = workouts.isNotEmpty ? workouts.last : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Your Fitness Summary",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Summary Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statCard("Workouts", "$totalWorkouts", Icons.fitness_center),
              _statCard("Duration", "$totalDuration min", Icons.timer),
              _statCard("Calories", "$totalCalories kcal", Icons.local_fire_department),
            ],
          ),
          const SizedBox(height: 30),

          // Last Workout
          Card(
            color: Colors.blueGrey[800],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: lastWorkout != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Last Workout",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Date: ${lastWorkout.date.toLocal().toString().split(' ')[0]}"),
                        Text("Core: ${lastWorkout.coreMuscle}"),
                        Text("Exercises: ${lastWorkout.exercises.map((e) => e.name).join(', ')}"),
                      ],
                    )
                  : const Text("No workout logged yet."),
            ),
          ),
          const SizedBox(height: 30),

          // Coming Soon Graph Placeholder
         const SizedBox(height: 30),
ElevatedButton.icon(
  icon: const Icon(Icons.directions_walk),
  label: const Text("Go to Step Counter"),
  onPressed: () {
    Navigator.of(context).pushNamed('/step-counter');
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: Colors.greenAccent.withOpacity(0.3),
  ),
),
const SizedBox(height: 12),
ElevatedButton.icon(
  icon: const Icon(Icons.local_fire_department),
  label: const Text("Go to Calorie Counter"),
  onPressed: () {
    Navigator.of(context).pushNamed('/calorie-counter');
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: Colors.redAccent.withOpacity(0.3),
  ),
),

        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: Colors.orangeAccent.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.orange),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
