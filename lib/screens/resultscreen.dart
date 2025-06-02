import 'package:flutter/material.dart';
import 'package:mood_application_project/screens/startscreen.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mood.dart';
import '../database/database_helper.dart';
import 'moodhistory.dart'; // Import Mood History Screen

class ResultScreen extends StatelessWidget {
  final VoidCallback onRestart;
  final VoidCallback onSuggest;
  final dynamic resultMood;

  const ResultScreen({
    Key? key,
    required this.resultMood,
    required this.onRestart,
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

  Future<void> saveMoodResult(BuildContext context) async {
    int result = await DatabaseHelper.instance.saveMood(
      resultMood.toString(),
      messages[resultMood]!,
    );
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Mood saved successfully! ID: $result"),
      duration: Duration(seconds: 2), // SnackBar visibility time
    ));
  }

  void _saveNote(BuildContext context,String note) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      'mood_history',
      {'mood': resultMood.toString(), 'note': note}, // Ensure the database has a 'note' column
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Note saved successfully!"),
      duration: Duration(seconds: 2), // Duration for visibility
    ),
  );
  }

  void _showAddNoteDialog(BuildContext context) {
    TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add a Note"),
          content: TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: "Enter your note"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
onPressed: () {
  if (_noteController.text.isNotEmpty) {
    _saveNote(context, _noteController.text); // Ensure context is passed
  }
  Navigator.pop(context);
},

              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result Screen')),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your Mood Result', style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 20),
            Text(messages[resultMood]!, style: const TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: onRestart, child: const Text('Restart Test')),
            const SizedBox(height: 12),
            ElevatedButton(
  onPressed: () async {
    await DatabaseHelper.instance.saveMood(
      resultMood.toString(),
      messages[resultMood]!,
      note: "", // Passing an empty note if user doesn't add one
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mood saved successfully!"),
        duration: Duration(seconds: 2),
      ),
    );
  },
  child: const Text('Save Result'),
),
 // Save mood and navigate to history
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _showAddNoteDialog(context),
              child: const Text('Add Note'),
            ),
            const SizedBox(height: 12),
            if (resultMood == Mood.Sad || resultMood == Mood.Tired || resultMood == Mood.Neutral)
              ElevatedButton(onPressed: onSuggest, child: const Text('Get Suggestions')),
          ],
        ),
      ),
    );
  }
}










