class ExerciseCategory {
  final String name;
  final String difficulty;
  final List<String> targetMuscles;

  ExerciseCategory({
    required this.name,
    required this.difficulty,
    required this.targetMuscles,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'difficulty': difficulty,
      'targetMuscles': targetMuscles,
    };
  }

  factory ExerciseCategory.fromJson(Map<String, dynamic> json) {
    return ExerciseCategory(
      name: json['name'],
      difficulty: json['difficulty'],
      targetMuscles: List<String>.from(json['targetMuscles']),
    );
  }

  @override
  String toString() => '$name ($difficulty)';
}
