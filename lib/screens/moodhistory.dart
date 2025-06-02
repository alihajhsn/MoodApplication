import 'package:flutter/material.dart';
import 'package:mood_application_project/screens/filterscreen.dart';
import '../database/database_helper.dart';

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({Key? key}) : super(key: key);

  @override
  _MoodHistoryScreenState createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen> {
  List<Map<String, dynamic>> moodList = [];
  
  // All filters are OFF by default so that ALL moods are shown initially.
  // If a user toggles one ON (true), only those moods will be displayed.
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
    loadMoodHistory();
  }

  /// Helper function to normalize mood types.
  /// Converts "sad", "SAD", or "sAd" to "Sad".
  String normalizeMoodType(String mood) {
    if (mood.isEmpty) return mood;
    return mood[0].toUpperCase() + mood.substring(1).toLowerCase();
  }

  Future<void> loadMoodHistory({Map<String, bool>? filters}) async {
    final moods = await DatabaseHelper.instance.getMoodHistory();

    // If filters are provided and at least one is ON, we filter the moods.
    if (filters != null && filters.containsValue(true)) {
      moodList = moods.where((mood) {
        final moodStr = (mood['moodType'] as String?) ?? "";
        final normalizedMood = normalizeMoodType(moodStr.trim());
        // Return true if the normalized mood type is enabled in filters.
        return filters[normalizedMood] == true;
      }).toList();

      print("Filtered Mood History: $moodList");  // Debugging
    } else {
      // If no filter is on, show all moods.
      moodList = moods;
      print("Showing all moods (no filters applied)");
    }

    setState(() {});
  }

  Future<void> deleteMood(int id) async {
    await DatabaseHelper.instance.deleteMood(id);
    loadMoodHistory(filters: activeFilters); // Refresh using current filters.
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
                mood['note'] != null && mood['note'].isNotEmpty
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
              child: Text("Mood Filters", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: const Text("Filter Results"),
              leading: const Icon(Icons.filter_list),
              onTap: () async {
                // Navigate to FilterScreen with the current filters.
                final selectedFilters = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterScreen(currentFilters: activeFilters),
                  ),
                );

                if (selectedFilters != null) {
                  print("Applying Filters: $selectedFilters"); // Debugging
                  setState(() {
                    activeFilters = selectedFilters; // Update filters globally.
                  });

                  loadMoodHistory(filters: activeFilters); // Apply filters.
                } else {
                  print("No filters selected, showing all moods."); // Debugging
                  loadMoodHistory(); // Show all moods if nothing is returned.
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 109, 142),
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
