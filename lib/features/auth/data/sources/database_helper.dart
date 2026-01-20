// =====================================
// Database Helper - مساعد قاعدة البيانات
// =====================================

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// مساعد SQLite لإدارة قاعدة البيانات
class DatabaseHelper {
  // Singleton pattern - instance واحد فقط
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  // الحصول على قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    // الحصول على مسار قاعدة البيانات
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_app.db');

    // فتح أو إنشاء قاعدة البيانات
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // إنشاء الجداول
  Future<void> _createDatabase(Database db, int version) async {
    // جدول المستخدمين
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    print('✅ تم إنشاء جدول المستخدمين بنجاح');
  }

  // إغلاق قاعدة البيانات
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // حذف قاعدة البيانات (للاختبار)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_app.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
