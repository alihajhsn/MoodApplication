// screens/moodhistory.dart

import 'package:flutter/material.dart';
import 'package:mood_application_project/screens/filterscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({Key? key}) : super(key: key);

  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  List<Map<String, dynamic>> moodList = [];
  
  // Maintain a map of available mood filters.
  Map<String, bool> activeFilters = {
    "Happy": false,
    "Confident": false,
    "Tired": false,
    "Loved": false,
    "Sad": false,
    "Neutral": false,
    "Relaxed": false,
  };

  @override
  void initState() {
    super.initState();
    loadSavedFilter();
  }
  
  Future<void> loadSavedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve a saved list of selected moods (if any)
    List<String>? savedMoodTypes = prefs.getStringList('selectedMoodTypes');
    setState(() {
      activeFilters = {
        "Happy": savedMoodTypes?.contains("Happy") ?? false,
        "Confident": savedMoodTypes?.contains("Confident") ?? false,
        "Tired": savedMoodTypes?.contains("Tired") ?? false,
        "Loved": savedMoodTypes?.contains("Loved") ?? false,
        "Sad": savedMoodTypes?.contains("Sad") ?? false,
        "Neutral": savedMoodTypes?.contains("Neutral") ?? false,
        "Relaxed": savedMoodTypes?.contains("Relaxed") ?? false,
      };
    });
    loadMoodHistory(moodTypes: savedMoodTypes);
  }
  
  // This function now accepts a list of selected mood types.
  Future<void> loadMoodHistory({List<String>? moodTypes}) async {
    if (moodTypes != null && moodTypes.isNotEmpty) {
      moodList = await DatabaseHelper.instance.getFilteredMoods(moodTypes);
    } else {
      moodList = await DatabaseHelper.instance.getMoodHistory();
    }
    setState(() {});
  }

  Future<void> deleteMood(int id) async {
    await DatabaseHelper.instance.deleteMood(id);
    List<String> selectedMoodTypes = activeFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    loadMoodHistory(moodTypes: selectedMoodTypes);
  }

  void _showMoodDetailsDialog(BuildContext context, Map<String, dynamic> mood) {
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
                (mood['note'] != null && mood['note'].isNotEmpty)
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Mood Filters",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: const Text("Filter Results"),
              leading: const Icon(Icons.filter_list),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                // Pass the current filters to the FilterScreen.
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FilterScreen(currentFilters: activeFilters),
                  ),
                );

                if (result != null && result is Map<String, bool>) {
                  setState(() {
                    activeFilters = result;
                  });
                  // Build a list of mood types that are selected (true).
                  List<String> selectedMoodTypes = activeFilters.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();
                  // Save the selected moods.
                  await prefs.setStringList('selectedMoodTypes', selectedMoodTypes);
                  loadMoodHistory(moodTypes: selectedMoodTypes);
                } else {
                  await prefs.remove('selectedMoodTypes');
                  setState(() {
                    activeFilters = {
                      "Happy": false,
                      "Confident": false,
                      "Tired": false,
                      "Loved": false,
                      "Sad": false,
                      "Neutral": false,
                      "Relaxed": false,
                    };
                  });
                  loadMoodHistory();
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
      body: moodList.isEmpty
          ? const Center(
              child: Text('No mood history available',
                  style: TextStyle(fontSize: 20)),
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
                        SnackBar(content: Text("${mood['moodType']} deleted")));
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child:
                        const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child:
                        const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.mood,
                          size: 30, color: Colors.blue),
                      title: Text(mood['moodType'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(mood['description']),
                      trailing: Text(
                        mood['date'].split('T')[0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () => _showMoodDetailsDialog(context, mood),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
