// =====================================
// User Data Source - مصدر بيانات المستخدمين
// =====================================

import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import 'database_helper.dart';

/// مصدر البيانات المحلي للمستخدمين
class UserDataSource {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // إضافة مستخدم جديد
  Future<bool> createUser(User user) async {
    try {
      final db = await _databaseHelper.database;

      // التحقق من عدم وجود بريد مسجل بالفعل
      final existing = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email],
      );

      if (existing.isNotEmpty) {
        throw Exception('البريد الإلكتروني مسجل بالفعل');
      }

      // إضافة المستخدم
      await db.insert('users', {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'password': user.password,
        'createdAt': user.createdAt.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      print('✅ تم إضافة المستخدم: ${user.email}');
      return true;
    } catch (e) {
      print('❌ خطأ في إضافة المستخدم: $e');
      throw Exception('خطأ في إضافة المستخدم: $e');
    }
  }

  // الحصول على مستخدم بـ ID
  Future<User?> getUserById(String id) async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.query('users', where: 'id = ?', whereArgs: [id]);

      if (results.isEmpty) {
        return null;
      }

      return User.fromJson(results.first as Map<String, dynamic>);
    } catch (e) {
      print('❌ خطأ في البحث عن المستخدم: $e');
      return null;
    }
  }

  // الحصول على مستخدم بـ البريد الإلكتروني
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (results.isEmpty) {
        return null;
      }

      return User.fromJson(results.first as Map<String, dynamic>);
    } catch (e) {
      print('❌ خطأ في البحث عن المستخدم: $e');
      return null;
    }
  }

  // الحصول على جميع المستخدمين
  Future<List<User>> getAllUsers() async {
    try {
      final db = await _databaseHelper.database;

      final results = await db.query('users');

      return results
          .map((user) => User.fromJson(user as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ خطأ في الحصول على المستخدمين: $e');
      return [];
    }
  }

  // تحديث بيانات المستخدم
  Future<bool> updateUser(User user) async {
    try {
      final db = await _databaseHelper.database;

      final result = await db.update(
        'users',
        {
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'password': user.password,
          'createdAt': user.createdAt.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (result == 0) {
        throw Exception('لم يتم العثور على المستخدم');
      }

      print('✅ تم تحديث المستخدم: ${user.email}');
      return true;
    } catch (e) {
      print('❌ خطأ في تحديث المستخدم: $e');
      throw Exception('خطأ في تحديث المستخدم: $e');
    }
  }

  // حذف مستخدم
  Future<bool> deleteUser(String id) async {
    try {
      final db = await _databaseHelper.database;

      final result = await db.delete('users', where: 'id = ?', whereArgs: [id]);

      if (result == 0) {
        throw Exception('لم يتم العثور على المستخدم');
      }

      print('✅ تم حذف المستخدم');
      return true;
    } catch (e) {
      print('❌ خطأ في حذف المستخدم: $e');
      throw Exception('خطأ في حذف المستخدم: $e');
    }
  }

  // حذف جميع المستخدمين
  Future<void> deleteAllUsers() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete('users');
      print('✅ تم حذف جميع المستخدمين');
    } catch (e) {
      print('❌ خطأ في حذف المستخدمين: $e');
    }
  }

  // عد المستخدمين
  Future<int> getUserCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('❌ خطأ في عد المستخدمين: $e');
      return 0;
    }
  }
}
