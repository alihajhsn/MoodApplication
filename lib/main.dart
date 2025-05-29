// lib/main.dart
import 'package:flutter/material.dart';
import 'models/mood.dart';
import 'data/questions.dart';
import 'screens/startscreen.dart';
import 'screens/questionscreen.dart';
import 'screens/resultscreen.dart';

void main() {
  runApp(const MoodTestApp());
}

class MoodTestApp extends StatefulWidget {
  const MoodTestApp({Key? key}) : super(key: key);

  @override
  State<MoodTestApp> createState() => _MoodTestAppState();
}

class _MoodTestAppState extends State<MoodTestApp> {
  int currentQuestionIndex = 0;
  Map<Mood, int> scores = {
    Mood.Happy: 0,
    Mood.Confident: 0,
    Mood.Tired: 0,
    Mood.Loved: 0,
    Mood.Sad: 0,
    Mood.Neutral: 0,
    Mood.Relaxed: 0,
  };
  bool testStarted = false;
  bool testEnded = false;
  Mood? finalResult;

  void startTest() {
    setState(() {
      testStarted = true;
      testEnded = false;
      currentQuestionIndex = 0;
      scores.updateAll((key, value) => 0);
    });
  }

  void answerQuestion(int answerIndex) {
    Mood selectedMood = questions[currentQuestionIndex].Answers[answerIndex].mood;
    setState(() {
      scores[selectedMood] = scores[selectedMood]! + 1;
      currentQuestionIndex++;
      if (currentQuestionIndex >= questions.length) {
        testEnded = true;
        finalResult = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      }
    });
  }

  void restartTest() {
    setState(() {
      testStarted = false;
      testEnded = false;
      scores.updateAll((key, value) => 0);
    });
  }

  void saveResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result saved successfully!')),
    );
  }

  void showSuggestions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Here are some suggestions to improve your mood!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigator(
        pages: [
          if (!testStarted)
            MaterialPage(child: StartScreen(onStartTest: startTest))
          else if (testEnded && finalResult != null)
            MaterialPage(
              child: ResultScreen(
                resultMood: finalResult!,
                onRestart: restartTest,
                onSave: saveResult,
                onSuggest: showSuggestions,
              ),
            )
          else
            MaterialPage(
              child: QuestionScreen(
                question: questions[currentQuestionIndex],
                onAnswerSelected: answerQuestion,
                onStartTest: restartTest,
              ),
            ),
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
    );
  }
}
