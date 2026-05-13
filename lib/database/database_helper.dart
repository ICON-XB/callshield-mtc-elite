import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('callshield_mtc.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. History Table: Every scan saved
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT NOT NULL,
        name TEXT,
        risk_level TEXT,
        timestamp TEXT,
        is_mtc INTEGER,
        photo_url TEXT
      )
    ''');

    // 2. Blacklist Table: Locally blocked numbers
    await db.execute('''
      CREATE TABLE blacklist (
        phone TEXT PRIMARY KEY,
        reason TEXT,
        added_at TEXT
      )
    ''');

    // 3. Reports Table: Local copy of submitted reports
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT,
        category TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> addToHistory(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert('history', data);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await instance.database;
    return await db.query('history', orderBy: 'id DESC');
  }

  // --- Community Reporting Logic ---
  
  Future<void> addReport(String phone, String category) async {
    final db = await instance.database;
    await db.insert('reports', {
      'phone': phone,
      'category': category,
      'status': 'submitted'
    });
  }

  Future<int> getReportCount(String phone) async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM reports WHERE phone = ?', [phone]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
