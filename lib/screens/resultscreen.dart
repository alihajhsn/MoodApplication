import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mood.dart';
import '../database/database_helper.dart';

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

Future<int> saveMoodResult(BuildContext context) async {
  int moodId = await DatabaseHelper.instance.saveMood(
    resultMood.toString(),
    messages[resultMood]!,
  );

  print("Mood saved with ID: $moodId"); // Debugging

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Mood saved successfully!"),
      duration: Duration(seconds: 2),
    ),
  );

  return moodId; // ✅ Return correct ID for note attachment
}



void _saveNote(BuildContext context, int moodId, String note) async {
  await DatabaseHelper.instance.updateMoodNote(moodId, note); // ✅ Correct mood entry

  print("Note saved!"); // Debugging confirmation

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Note saved successfully!"),
      duration: Duration(seconds: 2),
    ),
  );
}

Future<void> updateMoodNote(int moodId, String note) async {
  final Database db = await DatabaseHelper.instance.database;

  await db.update(
    'moods', 
    {'note': note},
    where: 'id = ?',
    whereArgs: [moodId], // ✅ Ensure correct mood ID is updated
  );

  print("Updated Mood ID: $moodId with Note: $note"); // Debugging
}



 void _showAddNoteDialog(BuildContext context, int moodId) {
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
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_noteController.text.isNotEmpty) {
                  _saveNote(context, moodId, _noteController.text);
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
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(messages[resultMood]!, style: const TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center),
            SizedBox(height: 8,),
            ElevatedButton(onPressed: onRestart, child: const Text('Restart Test')),
            SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () async {
                int moodId = await saveMoodResult(context); // ✅ Ensure mood ID is retrieved first

                print("Latest Mood ID for note attachment: $moodId"); // Debugging

                if (moodId != 0) {
                  _showAddNoteDialog(context, moodId); // ✅ Ensure correct mood entry is updated
                } else {
                  print("Error: Mood ID is invalid."); // Debugging if something goes wrong
                }
              },
              child: const Text('Save Result & Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}













