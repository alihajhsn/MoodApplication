import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../database/database_helper.dart';

class ResultScreen extends StatelessWidget {
  final VoidCallback onRestart;
  final dynamic resultMood;

  const ResultScreen({
    Key? key,
    required this.resultMood,
    required this.onRestart,
    
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

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Mood saved successfully!"),
      duration: Duration(seconds: 2),
    ),
  );

  return moodId; 
}



void _saveNote(BuildContext context, int moodId, String note) async {
  await DatabaseHelper.instance.updateMoodNote(moodId, note); 
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Note saved successfully!"),
      duration: Duration(seconds: 2),
    ),
  );
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
                  _saveNote(context, moodId, _noteController.text);
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
                int moodId = await saveMoodResult(context); 

                if (moodId != 0) {
                  _showAddNoteDialog(context, moodId); 
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













