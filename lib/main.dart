import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/workout.dart';
import 'screens/workout_form.dart';
import 'widgets/workout_list.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WorkoutHomePage(),
    );
  }
}

class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  State<WorkoutHomePage> createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('workouts');
    if (data != null) {
      final decoded = json.decode(data) as List;
      setState(() {
        _workouts = decoded.map((e) => Workout.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_workouts.map((e) => e.toJson()).toList());
    await prefs.setString('workouts', data);
  }

  void _addWorkout(Workout workout, [int? index]) {
    setState(() {
      if (index == null) {
        _workouts.add(workout);
      } else {
        _workouts[index] = workout;
      }
    });
    _saveWorkouts();
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
    _saveWorkouts();
  }

  void _editWorkout(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutForm(
          onSubmit: (updatedWorkout) => _addWorkout(updatedWorkout, index),
          existingWorkout: _workouts[index],
        ),
      ),
    );
  }

  void _startAddWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutForm(onSubmit: _addWorkout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Tracker")),
      body: _workouts.isEmpty
          ? const Center(child: Text("No Workouts Yet!"))
          : WorkoutList(
              workouts: _workouts,
              onEdit: _editWorkout,
              onDelete: _deleteWorkout,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAddWorkout(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Workout"),
      ),
    );
  }
}
