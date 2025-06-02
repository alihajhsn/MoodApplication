import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    sqfliteFfiInit(); // Ensure database factory is initialized
    databaseFactory = databaseFactoryFfi;

    // Use local database path (Windows compatible)
    String path = join(Directory.current.path, 'mood_history.db');
    
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE moods (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              moodType TEXT,
              description TEXT,
              note TEXT,  -- ✅ Added 'note' column
              
              date TEXT
            )
          ''');
        },
      ),
    );
  }

Future<int> saveMood(String moodType, String description, {String? note}) async {
  final Database db = await instance.database;

  print("Saving mood: $moodType, Description: $description, Note: $note");
  return await db.insert(
    'moods',
    {
      'moodType': moodType,
      'description': description,
      'note': note ?? "", // Adds note, defaults to empty string if null
      'date': DateTime.now().toIso8601String(),
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


  Future<int> deleteMood(int id) async {
  final db = await instance.database;
  return await db.delete('moods', where: 'id = ?', whereArgs: [id]);
}


  Future<List<Map<String, dynamic>>> getMoodHistory() async {
    final db = await instance.database;
    return await db.query('moods', orderBy: 'id DESC');
  }


Future<int> saveMoodWithNote(String moodType, String description, String note) async {
  final Database db = await instance.database;
  
  int result = await db.insert(
    'mood_history',
    {
      'moodType': moodType,
      'description': description,
      'note': note,
      'date': DateTime.now().toIso8601String(),
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print("Mood saved? ID: $result"); // Debugging check
  return result;
}

Future<void> deleteDatabaseFile() async {
  String dbPath = join(Directory.current.path, 'mood_history.db');
  File dbFile = File(dbPath);

  if (await dbFile.exists()) {
    await dbFile.delete();
    print("Database deleted successfully!");
  } else {
    print("Database file not found.");
  }
}


}

