import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("activity_log.db");
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath(); // 端末に保存されるパス
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //データベース作成
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hp (
        userId INTEGER NOT NULL,
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        health INTEGER DEFAULT 100,
        updatedAt TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE active (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        value INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE rest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        value INTEGER NOT NULL
      );
    ''');
  }
}
