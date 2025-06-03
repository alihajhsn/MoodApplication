// lib/screens/questionscreen.dart
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionScreen extends StatelessWidget {
  final Question question;
  final Function(int) onAnswerSelected;
  final VoidCallback onStartTest;

  
  const QuestionScreen({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.onStartTest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mood Test',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              question.text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(
              question.Answers.length,
              (index) => Column(
                children: [
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => onAnswerSelected(index),
                    child: Text(question.Answers[index].text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}