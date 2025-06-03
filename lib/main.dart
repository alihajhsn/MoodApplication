// lib/main.dart
import 'package:flutter/material.dart';
import 'package:mood_application_project/screens/moodhistory.dart';
import 'models/mood.dart';
import 'data/questions.dart';
import 'screens/startscreen.dart';
import 'screens/questionscreen.dart';
import 'screens/resultscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure async functions work


  runApp(MoodTestApp()); 
}


class MoodTestApp extends StatefulWidget {
  const MoodTestApp({Key? key}) : super(key: key);

  @override
  State<MoodTestApp> createState() => _MoodTestAppState();
}

class _MoodTestAppState extends State<MoodTestApp> {
  int _selectedIndex =0;
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

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
       
        body: Navigator(
          pages: [
             if (_selectedIndex == 1) 
              MaterialPage(child: MoodHistoryScreen()) 
            else if (!testStarted)
              MaterialPage(child: StartScreen(onStartTest: startTest))
            else if (testEnded)
              MaterialPage(
                child: ResultScreen(
                  
                  onRestart: restartTest, resultMood: finalResult,
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
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Start Test'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Mood History'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          
        ),
      ),
      
    );
  }
}
