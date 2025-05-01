import 'package:flutter/material.dart';

class CalorieCounterScreen extends StatelessWidget {
  const CalorieCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Counter'),
      ),
      body: const Center(
        child: Text(
          '🔥 Calorie Tracker\nComing Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
