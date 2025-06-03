// screens/filterscreen.dart

import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key, required this.currentFilters})
      : super(key: key);
  final Map<String, bool> currentFilters;

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Map<String, bool> localFilters;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the filters.
    localFilters = Map<String, bool>.from(widget.currentFilters);
  }

  void _applyFilters() {
    // Return the updated filters without altering other mood values.
    Navigator.pop(context, localFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Mood History"),
        leading: BackButton(
          onPressed: _applyFilters,
        ),
      ),
      body: ListView(
        children: localFilters.keys.map((mood) {
          return SwitchListTile(
            title: Text(mood),
            subtitle: Text("Show only $mood moods"),
            value: localFilters[mood]!,
            onChanged: (bool value) {
              setState(() {
                localFilters[mood] = value;
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _applyFilters,
        icon: const Icon(Icons.done),
        label: const Text("Apply Filters"),
      ),
    );
  }
}
