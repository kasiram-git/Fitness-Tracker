import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/workout.dart';
import 'screens/workout_form.dart';
import 'screens/step_counter.dart';
import 'screens/calorie_counter.dart';
import 'widgets/workout_list.dart';
import 'widgets/dashboard.dart';

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
      home: const MainScreen(),
      routes: {
        '/step-counter': (context) => const StepCounterScreen(),
        '/calorie-counter': (context) => const CalorieCounterScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Workout> _workouts = [];
  int _selectedIndex = 0;

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

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Dashboard(workouts: _workouts),
      WorkoutList(
        workouts: _workouts,
        onEdit: _editWorkout,
        onDelete: _deleteWorkout,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Dashboard' : 'Workout Logs'),
      ),
      body: tabs[_selectedIndex],
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => _startAddWorkout(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Workout"),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Workouts"),
        ],
      ),
    );
  }
}
