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
  List<String> _customTargetMuscles = [];

  final List<ExerciseCategory> _selectedExercises = [];
  final List<ExerciseCategory> _allExercises = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Map<String, String> _muscleEmojis = {
    "Chest": "🫀",
    "Legs": "🦵",
    "Biceps": "💪",
    "Triceps": "🫱",
    "Shoulders": "🤸",
    "Back": "🔙",
  };

  List<String> get _coreOptions => _muscleEmojis.keys.toList();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    if (widget.existingWorkout != null) {
      _durationController.text = widget.existingWorkout!.duration.toString();
      _caloriesController.text =
          widget.existingWorkout!.caloriesBurned.toString();
      _selectedCore = widget.existingWorkout!.coreMuscle;
      _selectedExercises.addAll(widget.existingWorkout!.exercises);
      _allExercises.addAll(widget.existingWorkout!.exercises);
    } else {
      _allExercises.addAll([
        ExerciseCategory(
            name: "Push-ups",
            difficulty: "",
            targetMuscles: ["Chest", "Triceps"]),
        ExerciseCategory(
            name: "Squats", difficulty: "", targetMuscles: ["Legs"]),
        ExerciseCategory(
            name: "Shoulder Press",
            difficulty: "",
            targetMuscles: ["Shoulders"]),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  void _addCustomExercise() {
    final name = _exerciseNameController.text.trim();
    if (name.isNotEmpty && _customTargetMuscles.isNotEmpty) {
      final newExercise = ExerciseCategory(
        name: name,
        difficulty: "",
        targetMuscles: List.from(_customTargetMuscles),
      );
      setState(() {
        _allExercises.add(newExercise);
        _selectedExercises.add(newExercise);
        _exerciseNameController.clear();
        _customTargetMuscles.clear();
      });
    }
  }

  InputDecoration _inputStyle(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.grey.shade900,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  String formatMuscle(String muscle) {
    final emoji = _muscleEmojis[muscle] ?? "💪";
    return "$emoji $muscle";
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(title: 
        Text("Workout Details",
      style: Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontWeight: FontWeight.bold)),),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Workout Details",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          decoration: _inputStyle("Duration (min)",
                              icon: Icons.timer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: _inputStyle("Calories Burned",
                              icon: Icons.local_fire_department),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCore,
                    items: _coreOptions.map((core) {
                      return DropdownMenuItem(
                        value: core,
                        child: Text(formatMuscle(core)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCore = value;
                      });
                    },
                    decoration: _inputStyle("💪 Core Muscle Group"),
                  ),

                  const SizedBox(height: 24),
                  Text("Select Exercises",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _allExercises[index];
                      final isSelected = _selectedExercises.contains(exercise);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected
                                  ? Colors.greenAccent
                                  : Colors.grey.shade700),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: Icon(Icons.fitness_center,
                              color: isSelected
                                  ? Colors.greenAccent
                                  : Colors.grey),
                          title: Text(exercise.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          subtitle: Wrap(
                            spacing: 6,
                            children: exercise.targetMuscles.map((muscle) {
                              return Chip(
                                label: Text(formatMuscle(muscle),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                backgroundColor: Colors.deepPurpleAccent,
                              );
                            }).toList(),
                          ),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                val == true
                                    ? _selectedExercises.add(exercise)
                                    : _selectedExercises.remove(exercise);
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? _selectedExercises.remove(exercise)
                                  : _selectedExercises.add(exercise);
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const Divider(height: 32),
                  Text("➕ Add Custom Exercise",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: Colors.grey.shade800,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            controller: _exerciseNameController,
                            decoration: _inputStyle("Exercise Name",
                                icon: Icons.edit),
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Select Target Muscles",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _coreOptions.map((muscle) {
                              final selected =
                                  _customTargetMuscles.contains(muscle);
                              return FilterChip(
                                label: Text(formatMuscle(muscle)),
                                selected: selected,
                                onSelected: (val) {
                                  setState(() {
                                    val
                                        ? _customTargetMuscles.add(muscle)
                                        : _customTargetMuscles.remove(muscle);
                                  });
                                },
                                backgroundColor: Colors.grey,
                                selectedColor: Colors.teal,
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _addCustomExercise,
                              icon: const Icon(Icons.add_circle),
                              label: const Text("Add Exercise"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.greenAccent.withOpacity(0.3),
                                foregroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Workout"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
