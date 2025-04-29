import 'exercise_category.dart';

class Workout {
  final DateTime date;
  final List<ExerciseCategory> exercises;
  final int duration;
  final int caloriesBurned;
  final String coreMuscle;

  Workout({
    required this.date,
    required this.exercises,
    required this.duration,
    required this.caloriesBurned,
    required this.coreMuscle,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'coreMuscle': coreMuscle,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      date: DateTime.parse(json['date']),
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseCategory.fromJson(e))
          .toList(),
      duration: json['duration'],
      caloriesBurned: json['caloriesBurned'],
      coreMuscle: json['coreMuscle'],
    );
  }
}
