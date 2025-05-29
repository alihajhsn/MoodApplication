// lib/screens/startscreen.dart
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final VoidCallback onStartTest;

  const StartScreen({Key? key, required this.onStartTest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Screen'),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onStartTest,
              child: const Text('Start Test'),
            ),
          ],
        ),
      ),
    );
  }
}