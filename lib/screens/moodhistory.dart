import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({Key? key}) : super(key: key);

  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  List<Map<String, dynamic>> moodList = [];

  @override
  void initState() {
    super.initState();
    loadMoodHistory();
  }

  Future<void> loadMoodHistory() async {
    final moods = await DatabaseHelper.instance.getMoodHistory();
    setState(() {
      moodList = moods;
    });
  }

  Future<void> deleteMood(int id) async {
    await DatabaseHelper.instance.deleteMood(id);
    loadMoodHistory(); // Refresh list after deletion
  }

void _showMoodDetailsDialog(BuildContext context, Map<String, dynamic> mood, List<Map<String, dynamic>> moodList) {
  print("Mood list data: $moodList"); // Debugging - prints the full list of moods

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(mood['moodType']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${mood['description']}"),
            const SizedBox(height: 10),
            Text(
              mood.containsKey('note') && mood['note'] != null && mood['note'].isNotEmpty
                  ? "Note: ${mood['note']}"
                  : "No note added",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood History')),
      body: moodList.isEmpty
          ? const Center(
              child: Text('No mood history available', style: TextStyle(fontSize: 20)),
            )
          : ListView.builder(
              itemCount: moodList.length,
              itemBuilder: (context, index) {
                final mood = moodList[index];
                return Dismissible(
                  key: Key(mood['id'].toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    deleteMood(mood['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${mood['moodType']} deleted")),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.mood, size: 30, color: Colors.blue),
                      title: Text(mood['moodType'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(mood['description']),
                      trailing: Text(
                        mood['date'].split('T')[0], // Show date only
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () => _showMoodDetailsDialog(context, mood,moodList), // Opens mood details dialog
                    ),
                  ),
                );
              },
            ),
    );
  }
}






