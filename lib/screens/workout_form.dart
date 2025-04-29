import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/exercise_category.dart';

class WorkoutForm extends StatefulWidget {
  final Function(Workout) onSubmit;
  final Workout? existingWorkout;

  const WorkoutForm({
    super.key,
    required this.onSubmit,
    this.existingWorkout,
  });

  @override
  State<WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm>
    with SingleTickerProviderStateMixin {
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _exerciseNameController = TextEditingController();
  String? _selectedCore;
  final List<ExerciseCategory> _selectedExercises = [];
  final List<ExerciseCategory> _allExercises = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _coreOptions = [
    "Chest",
    "Legs",
    "Biceps",
    "Triceps",
    "Shoulders",
    "Back"
  ];

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    if (widget.existingWorkout != null) {
      _durationController.text =
          widget.existingWorkout!.duration.toString();
      _caloriesController.text =
          widget.existingWorkout!.caloriesBurned.toString();
      _selectedCore = widget.existingWorkout!.coreMuscle;
      _selectedExercises.addAll(widget.existingWorkout!.exercises);
      _allExercises.addAll(widget.existingWorkout!.exercises);
    } else {
      _allExercises.addAll([
        ExerciseCategory(name: "Push-ups", difficulty: "Easy", targetMuscles: ["Chest"]),
        ExerciseCategory(name: "Squats", difficulty: "Medium", targetMuscles: ["Legs"]),
        ExerciseCategory(name: "Burpees", difficulty: "Hard", targetMuscles: ["Full Body"]),
      ]);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _exerciseNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    try {
      final duration = int.parse(_durationController.text);
      final calories = int.parse(_caloriesController.text);

      if (_selectedCore == null || _selectedCore!.isEmpty) {
        throw Exception("Please select a core muscle group.");
      }

      if (_selectedExercises.isEmpty) {
        throw Exception("Please select at least one exercise.");
      }

      final workout = Workout(
        date: DateTime.now(),
        duration: duration,
        caloriesBurned: calories,
        exercises: List.from(_selectedExercises),
        coreMuscle: _selectedCore!,
      );

      widget.onSubmit(workout);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _addCustomExercise() {
    final name = _exerciseNameController.text.trim();
    if (name.isNotEmpty) {
      final newExercise = ExerciseCategory(
        name: name,
        difficulty: "Custom",
        targetMuscles: [_selectedCore ?? "General"],
      );
      setState(() {
        _allExercises.add(newExercise);
        _selectedExercises.add(newExercise);
        _exerciseNameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(title: const Text("Log Workout")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Workout Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (min)",
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories Burned",
                  prefixIcon: Icon(Icons.local_fire_department),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCore,
                items: _coreOptions.map((core) {
                  return DropdownMenuItem(
                    value: core,
                    child: Text(core),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCore = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Core Muscle Group",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Select Exercises", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                children: _allExercises.map((exercise) {
                  final isSelected = _selectedExercises.contains(exercise);
                  return CheckboxListTile(
                    title: Text(exercise.toString()),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        val == true
                            ? _selectedExercises.add(exercise)
                            : _selectedExercises.remove(exercise);
                      });
                    },
                  );
                }).toList(),
              ),
              const Divider(height: 32),
              const Text("Add Custom Exercise", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _exerciseNameController,
                      decoration: const InputDecoration(
                        hintText: "Exercise Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addCustomExercise,
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Workout"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
