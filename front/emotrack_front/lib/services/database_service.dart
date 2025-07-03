import 'dart:io';
import 'package:emotrack_front/models/diary_entry.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocDir.path, 'diary.db');

    final parentDir = Directory(p.dirname(dbPath));
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    print('✅ DB 경로: $dbPath');

    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
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
      ),
    );
  }

  // ✅ INSERT
  Future<void> insertDiary(DiaryEntry entry) async {
    final db = await database;
    await db.insert(
      'diaries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ SELECT ALL
  Future<List<DiaryEntry>> getDiaries() async {
    final db = await database;
    final maps = await db.query('diaries');
    return maps.map((map) => DiaryEntry.fromMap(map)).toList();
  }

  // ✅ UPDATE
  Future<void> updateDiary(DiaryEntry entry) async {
    final db = await database;
    await db.update(
      'diaries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  // ✅ DELETE
  Future<void> deleteDiary(int id) async {
    final db = await database;
    await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }
}
