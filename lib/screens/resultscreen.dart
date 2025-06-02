import 'package:flutter/material.dart';
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

  Future<void> saveMoodResult(BuildContext context) async {
    int result = await DatabaseHelper.instance.saveMood(
      resultMood.toString(),
      messages[resultMood]!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mood saved successfully! ID: $result"),
        duration: Duration(seconds: 2),
      ),
    );
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
      appBar: AppBar(title: const Text('Result Screen')),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(messages[resultMood]!, style: const TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center ,),
            const SizedBox(height: 8,),
            ElevatedButton(onPressed: onRestart, child: const Text('Restart Test')),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () => saveMoodResult(context),
              child: const Text('Save Result'),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: () => _showAddNoteDialog(context, 1), // Temporary ID, replace dynamically
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}













