//database_helper.dart

// Author: Adrienne Chiu (2025)
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sleepapp.db');

    return await openDatabase(
      path,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        height REAL,
        weight REAL,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // If users already had an older table, add any missing columns safely.
    // We probe existing columns and then ALTER TABLE for the missing ones.
    final cols = await db
        .rawQuery("PRAGMA table_info(users)"); // rows: {cid, name, type, ...}
    final have = {for (final r in cols) (r['name'] as String).toLowerCase(): true};

    Future<void> addIfMissing(String name, String type, [String defaultSql = '']) async {
      if (!have.containsKey(name.toLowerCase())) {
        // Note: SQLite supports ADD COLUMN with a default literal if needed.
        // Keep default empty to avoid schema surprises.
        await db.execute('ALTER TABLE users ADD COLUMN $name $type $defaultSql');
      }
    }

    // Add columns if they don't exist (handles very old installs)
    await addIfMissing('name', 'TEXT');
    await addIfMissing('age', 'INTEGER');
    await addIfMissing('height', 'REAL');
    await addIfMissing('weight', 'REAL');
    await addIfMissing('email', 'TEXT');
    await addIfMissing('password', 'TEXT');
  }

  // Insert a new user
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update user fields by email (e.g., fill in missing name/age later)
  Future<int> updateUserByEmail(String email, Map<String, dynamic> fields) async {
    final db = await database;
    return await db.update(
      'users',
      fields,
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Get a user by email
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}

