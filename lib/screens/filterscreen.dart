import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.currentFilters});

  final Map<String, bool> currentFilters;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool _happyFilter;
  late bool _confidentFilter;
  late bool _tiredFilter;
  late bool _lovedFilter;
  late bool _sadFilter;
  late bool _neutralFilter;
  late bool _relaxedFilter;

  @override
  void initState() {
    super.initState();
    // Initialize filter states based on current selection
    _happyFilter = widget.currentFilters["Happy"] ?? false;
    _confidentFilter = widget.currentFilters["Confident"] ?? false;
    _tiredFilter = widget.currentFilters["Tired"] ?? false;
    _lovedFilter = widget.currentFilters["Loved"] ?? false;
    _sadFilter = widget.currentFilters["Sad"] ?? false;
    _neutralFilter = widget.currentFilters["Neutral"] ?? false;
    _relaxedFilter = widget.currentFilters["Relaxed"] ?? false;
  }

  void _applyFilters() {
    final selectedFilters = {
      "Happy": _happyFilter,
      "Confident": _confidentFilter,
      "Tired": _tiredFilter,
      "Loved": _lovedFilter,
      "Sad": _sadFilter,
      "Neutral": _neutralFilter,
      "Relaxed": _relaxedFilter,
    };

    // If all filters are OFF OR all are ON, return all moods
    if (!selectedFilters.containsValue(true) || selectedFilters.values.every((value) => value)) {
      print("All moods will be displayed"); // Debugging
      Navigator.pop(context, {}); // ✅ Empty filter list, meaning show all moods
    } else {
      print("Applying selected filters: $selectedFilters"); // Debugging
      Navigator.pop(context, selectedFilters); // ✅ Returns selected filters to MoodHistoryScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Mood History"),
        leading: BackButton(
          onPressed: _applyFilters, // ✅ Ensure filters are applied when returning
        ),
      ),
      body: Column(
        children: [
          _buildSwitch("Happy", "Only show happy moods.", _happyFilter, (value) => setState(() => _happyFilter = value)),
          _buildSwitch("Confident", "Only show confident moods.", _confidentFilter, (value) => setState(() => _confidentFilter = value)),
          _buildSwitch("Tired", "Only show tired moods.", _tiredFilter, (value) => setState(() => _tiredFilter = value)),
          _buildSwitch("Loved", "Only show loved moods.", _lovedFilter, (value) => setState(() => _lovedFilter = value)),
          _buildSwitch("Sad", "Only show sad moods.", _sadFilter, (value) => setState(() => _sadFilter = value)),
          _buildSwitch("Neutral", "Only show neutral moods.", _neutralFilter, (value) => setState(() => _neutralFilter = value)),
          _buildSwitch("Relaxed", "Only show relaxed moods.", _relaxedFilter, (value) => setState(() => _relaxedFilter = value)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _applyFilters,
        icon: const Icon(Icons.done),
        label: const Text("Apply Filters"),
      ),
    );
  }

  Widget _buildSwitch(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
    );
  }
}
