import 'package:flutter/material.dart';

class StepCounterScreen extends StatelessWidget {
  const StepCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
      ),
      body: const Center(
        child: Text(
          '🚶 Step Counter\nComing Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
