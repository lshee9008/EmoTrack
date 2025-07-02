import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/diary_entry.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'diary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diaries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            diary TEXT,
            date TEXT,
            summary TEXT,
            emotion TEXT,
            weather TEXT,
            song TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDiary(DiaryEntry entry) async {
    final db = await database;
    await db.insert(
      'diaries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DiaryEntry>> getDiaries() async {
    final db = await database;
    final maps = await db.query('diaries');
    return List.generate(maps.length, (i) => DiaryEntry.fromMap(maps[i]));
  }

  Future<DiaryEntry?> getDiary(int id) async {
    final db = await database;
    final maps = await db.query('diaries', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DiaryEntry.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateDiary(DiaryEntry entry) async {
    final db = await database;
    await db.update(
      'diaries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteDiary(int id) async {
    final db = await database;
    await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }
}
