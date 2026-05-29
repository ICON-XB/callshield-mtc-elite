import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (kIsWeb) return null; // Web doesn't support sqflite directly
    if (_database != null) return _database!;
    _database = await _initDB('callshield_mtc.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    final db = await openDatabase(path, version: 1, onCreate: _createDB);
    await db.execute('CREATE TABLE IF NOT EXISTS app_settings (key TEXT PRIMARY KEY, value TEXT)');
    return db;
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

  // --- In-Memory Mock for Web ---
  final List<Map<String, dynamic>> _webHistory = [];
  final List<Map<String, dynamic>> _webReports = [];

  Future<void> addToHistory(Map<String, dynamic> data) async {
    if (kIsWeb) {
      _webHistory.insert(0, data);
      return;
    }
    final db = await instance.database;
    if (db != null) await db.insert('history', data);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    if (kIsWeb) return _webHistory;
    final db = await instance.database;
    if (db == null) return [];
    return await db.query('history', orderBy: 'id DESC');
  }

  // --- Community Reporting Logic ---
  
  Future<void> addReport(String phone, String category) async {
    if (kIsWeb) {
      _webReports.add({'phone': phone, 'category': category, 'status': 'submitted'});
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert('reports', {
        'phone': phone,
        'category': category,
        'status': 'submitted'
      });
    }
  }

  Future<int> getReportCount(String phone) async {
    if (kIsWeb) {
      return _webReports.where((r) => r['phone'] == phone).length;
    }
    final db = await instance.database;
    if (db == null) return 0;
    final result = await db.rawQuery('SELECT COUNT(*) FROM reports WHERE phone = ?', [phone]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- App Settings Logic ---
  final Map<String, String> _webSettings = {};

  Future<void> saveSetting(String key, String value) async {
    if (kIsWeb) {
      _webSettings[key] = value;
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert(
        'app_settings',
        {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<String?> getSetting(String key) async {
    if (kIsWeb) {
      return _webSettings[key];
    }
    final db = await instance.database;
    if (db == null) return null;
    final maps = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }
}
