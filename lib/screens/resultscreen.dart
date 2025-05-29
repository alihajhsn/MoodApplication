// lib/screens/resultscreen.dart
import 'package:flutter/material.dart';
import 'package:mood_application_project/screens/startscreen.dart';
import '../models/mood.dart';

class ResultScreen extends StatelessWidget {
  final Mood resultMood;
  final VoidCallback onRestart;
  final VoidCallback onSave;
  final VoidCallback onSuggest;

  const ResultScreen({
    Key? key,
    required this.resultMood,
    required this.onRestart,
    required this.onSave,
    required this.onSuggest,
  }) : super(key: key);

  static const Map<Mood, String> messages = {
    Mood.Happy: "You're feeling Happy! Keep up the good vibes! 😊",
    Mood.Confident: "You're feeling Confident! Rock on! 💪",
    Mood.Tired: "You're feeling Tired. Try to get some rest. 😴",
    Mood.Loved: "You're feeling Loved. Cherish the moment. 💖",
    Mood.Sad: "You're feeling Sad. Take care and talk to someone. 😢",
    Mood.Neutral: "You're feeling Neutral. Find a spark to light up your day. ⚖️",
    Mood.Relaxed: "You're feeling Relaxed. Enjoy the peace. 🌿",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => StartScreen(onStartTest: () {}),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your Mood Result', style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 20),
            Text(
              messages[resultMood]!,
              style: const TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onRestart,
              child: const Text('Restart Test'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Save Result'),
            ),
            const SizedBox(height: 12),
            if (resultMood == Mood.Sad || resultMood == Mood.Tired || resultMood == Mood.Neutral)
              ElevatedButton(
                onPressed: onSuggest,
                child: const Text('Get Suggestions'),
              ),
          ],
        ),
      ),
    );
  }
}


