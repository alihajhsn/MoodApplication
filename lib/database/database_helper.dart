//database/database_helper.dart

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
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
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    String path = join(Directory.current.path, 'moods.db'); // ✅ Fix database name
    
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
              note TEXT, 
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
        'note': note ?? "", 
        'date': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMoodNote(int id, String note) async {
    final Database db = await instance.database;

    await db.update(
      'moods', 
      {'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );

    print("Updated Mood ID: $id with Note: $note");
  }

  Future<int> deleteMood(int id) async {
    final db = await instance.database;
    return await db.delete('moods', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getMoodHistory() async {
    final db = await instance.database;
    final moods = await db.query('moods', orderBy: 'id DESC');
    
    return moods;
  }
  
// database/database_helper.dart (excerpt)

Future<List<Map<String, dynamic>>> getFilteredMoods(List<String> moodTypes) async {
  final db = await instance.database;
  // Create placeholders (?) for each mood type.
  String placeholders = List.filled(moodTypes.length, '?').join(', ');
  final moods = await db.query(
    'moods',
    where: 'moodType IN ($placeholders)',
    whereArgs: moodTypes,
    orderBy: 'id DESC',
  );
  return moods;
}


}



