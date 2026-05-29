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
    final db = await openDatabase(path,
        version: 3, onCreate: _createDB, onUpgrade: _onUpgrade);
    await db.execute(
        'CREATE TABLE IF NOT EXISTS app_settings (key TEXT PRIMARY KEY, value TEXT)');
    return db;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add family protection tables in v2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS family_profiles (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          members TEXT,
          created_at TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS shared_blocklist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          family_id TEXT NOT NULL,
          phone TEXT NOT NULL,
          reason TEXT,
          added_by TEXT,
          added_at TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add smart rules table in v3
      await db.execute('''
        CREATE TABLE IF NOT EXISTS smart_rules (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          pattern TEXT NOT NULL,
          action TEXT NOT NULL,
          enabled INTEGER DEFAULT 1,
          owner TEXT,
          created_at TEXT
        )
      ''');
    }
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

    // 4. Family Profiles Table: grouping for family protection (v2)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS family_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        members TEXT,
        created_at TEXT
      )
    ''');

    // 5. Shared Blocklist Table: numbers shared across a family
    await db.execute('''
      CREATE TABLE IF NOT EXISTS shared_blocklist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        family_id TEXT NOT NULL,
        phone TEXT NOT NULL,
        reason TEXT,
        added_by TEXT,
        added_at TEXT
      )
    ''');
  }

  // --- In-Memory Mock for Web ---
  final List<Map<String, dynamic>> _webHistory = [];
  final List<Map<String, dynamic>> _webReports = [];
  final List<Map<String, dynamic>> _webFamilyProfiles = [];
  final List<Map<String, dynamic>> _webSharedBlocks = [];
  final List<Map<String, dynamic>> _webSmartRules = [];

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
      _webReports
          .add({'phone': phone, 'category': category, 'status': 'submitted'});
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert('reports',
          {'phone': phone, 'category': category, 'status': 'submitted'});
    }
  }

  Future<int> getReportCount(String phone) async {
    if (kIsWeb) {
      return _webReports.where((r) => r['phone'] == phone).length;
    }
    final db = await instance.database;
    if (db == null) return 0;
    final result = await db
        .rawQuery('SELECT COUNT(*) FROM reports WHERE phone = ?', [phone]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- Family Protection Methods ---

  Future<void> addFamilyProfile(Map<String, dynamic> profile) async {
    if (kIsWeb) {
      _webFamilyProfiles.add(profile);
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert('family_profiles', profile,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getFamilyProfiles() async {
    if (kIsWeb) return _webFamilyProfiles;
    final db = await instance.database;
    if (db == null) return [];
    return await db.query('family_profiles', orderBy: 'created_at DESC');
  }

  Future<void> addSharedBlock(String familyId, String phone,
      {String? reason, String? addedBy}) async {
    final entry = {
      'family_id': familyId,
      'phone': phone,
      'reason': reason ?? '',
      'added_by': addedBy ?? '',
      'added_at': DateTime.now().toIso8601String()
    };
    if (kIsWeb) {
      _webSharedBlocks.add(entry);
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert('shared_blocklist', entry);
    }
  }

  Future<List<Map<String, dynamic>>> getSharedBlocklist(String familyId) async {
    if (kIsWeb) {
      return _webSharedBlocks.where((b) => b['family_id'] == familyId).toList();
    }
    final db = await instance.database;
    if (db == null) return [];
    return await db.query('shared_blocklist',
        where: 'family_id = ?',
        whereArgs: [familyId],
        orderBy: 'added_at DESC');
  }

  Future<void> removeSharedBlock(String familyId, String phone) async {
    if (kIsWeb) {
      _webSharedBlocks.removeWhere(
          (b) => b['family_id'] == familyId && b['phone'] == phone);
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.delete('shared_blocklist',
          where: 'family_id = ? AND phone = ?', whereArgs: [familyId, phone]);
    }
  }

  // --- Smart Rules Methods ---

  Future<void> addSmartRule(Map<String, dynamic> rule) async {
    if (kIsWeb) {
      _webSmartRules.add(rule);
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.insert('smart_rules', rule,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getSmartRules() async {
    if (kIsWeb) return _webSmartRules;
    final db = await instance.database;
    if (db == null) return [];
    return await db.query('smart_rules', orderBy: 'created_at DESC');
  }

  Future<void> updateSmartRule(String id, Map<String, dynamic> rule) async {
    if (kIsWeb) {
      final idx = _webSmartRules.indexWhere((r) => r['id'] == id);
      if (idx >= 0) _webSmartRules[idx] = rule;
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.update('smart_rules', rule, where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<void> deleteSmartRule(String id) async {
    if (kIsWeb) {
      _webSmartRules.removeWhere((r) => r['id'] == id);
      return;
    }
    final db = await instance.database;
    if (db != null) {
      await db.delete('smart_rules', where: 'id = ?', whereArgs: [id]);
    }
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
