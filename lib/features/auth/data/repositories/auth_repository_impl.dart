// =====================================
// Auth Repository Implementation
// تطبيق مستودع المصادقة
// =====================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation الفعلية لـ AuthRepository
/// هنا بنحط الـ Business Logic بتاع التسجيل الدخول
class AuthRepositoryImpl implements AuthRepository {
  // متغير بيخزن SharedPreferences
  late SharedPreferences _prefs;

  // مفتاح لتخزين المستخدمين
  static const String _usersKey = 'users_list';
  static const String _currentUserKey = 'current_user';

  // متغير بيخزن المستخدم الحالي
  User? _currentUser;

  // قائمة المستخدمين المحملة من التخزين
  List<User> _users = [];

  // Constructor
  AuthRepositoryImpl() {
    _initializePrefs();
  }

  /// تهيئة SharedPreferences وتحميل البيانات المحفوظة
  Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUsers();
    await _loadCurrentUser();
  }

  /// تحميل المستخدمين من التخزين المحلي
  Future<void> _loadUsers() async {
    final usersJson = _prefs.getString(_usersKey);
    if (usersJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(usersJson);
        _users = decoded.map((user) => User.fromJson(user)).toList();
      } catch (e) {
        // إذا حدث خطأ في القراءة، نبدأ بقائمة فارغة
        _users = [
          User(
            id: '1',
            firstName: 'Test',
            lastName: 'User',
            email: 'test@example.com',
            password: 'password123',
          ),
        ];
        await _saveUsers();
      }
    } else {
      // إذا ما في بيانات محفوظة، نبدأ ببيانات افتراضية
      _users = [
        User(
          id: '1',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          password: 'password123',
        ),
      ];
      await _saveUsers();
    }
  }

  /// تحميل المستخدم الحالي من التخزين المحلي
  Future<void> _loadCurrentUser() async {
    final userJson = _prefs.getString(_currentUserKey);
    if (userJson != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userJson));
      } catch (e) {
        _currentUser = null;
      }
    }
  }

  /// حفظ المستخدمين في التخزين المحلي
  Future<void> _saveUsers() async {
    final usersJson = jsonEncode(_users.map((user) => user.toJson()).toList());
    await _prefs.setString(_usersKey, usersJson);
  }

  /// حفظ المستخدم الحالي في التخزين المحلي
  Future<void> _saveCurrentUser(User? user) async {
    if (user != null) {
      await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    } else {
      await _prefs.remove(_currentUserKey);
    }
  }

  /// تطبيق method تسجيل الدخول
  @override
  Future<User> login(String email, String password) async {
    // تأكد من تهيئة SharedPreferences
    if (_users.isEmpty) {
      await _loadUsers();
    }

    // نحاكي تأخير الشبكة (مثل API call)
    await Future.delayed(const Duration(seconds: 2));

    // نبحث عن المستخدم برايح الـ email والـ password
    try {
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      // لو لقينا المستخدم، نخزنه ونرجعه
      _currentUser = user;
      await _saveCurrentUser(user);
      return user;
    } catch (e) {
      // لو مالقناش المستخدم، نرمي exception
      throw Exception('بيانات تسجيل الدخول غير صحيحة');
    }
  }

  /// تطبيق method التسجيل الجديد
  @override
  Future<User> register(String email, String password, String name) async {
    // تأكد من تهيئة SharedPreferences
    if (_users.isEmpty) {
      await _loadUsers();
    }

    // نحاكي تأخير الشبكة
    await Future.delayed(const Duration(seconds: 2));

    // نتحقق إن البريد مش مسجل بالفعل
    final existingUser = _users.where((user) => user.email == email);
    if (existingUser.isNotEmpty) {
      throw Exception('البريد الإلكتروني مسجل بالفعل');
    }

    // نإنشي user جديد
    final newUser = User(
      id: DateTime.now().toString(), // معرف بناءً على الوقت الحالي
      firstName: name.split(' ').isNotEmpty ? name.split(' ')[0] : '',
      lastName: name.split(' ').length > 1
          ? name.split(' ').sublist(1).join(' ')
          : '',
      email: email,
      password: password,
    );

    // نضيفه في قائمة المستخدمين
    _users.add(newUser);
    // نحفظ المستخدمين
    await _saveUsers();
    // نخزنه كمستخدم حالي
    _currentUser = newUser;
    await _saveCurrentUser(newUser);

    return newUser;
  }

  /// Method جديد للتسجيل مع الاسم الأول والأخير
  Future<User> registerWithDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // تأكد من تهيئة SharedPreferences
    if (_users.isEmpty) {
      await _loadUsers();
    }

    // نحاكي تأخير الشبكة
    await Future.delayed(const Duration(seconds: 2));

    // نتحقق إن البريد مش مسجل بالفعل
    final existingUser = _users.where((user) => user.email == email);
    if (existingUser.isNotEmpty) {
      throw Exception('البريد الإلكتروني مسجل بالفعل');
    }

    // نإنشي user جديد
    final newUser = User(
      id: DateTime.now().toString(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    // نضيفه في قائمة المستخدمين
    _users.add(newUser);
    // نحفظ المستخدمين
    await _saveUsers();
    // نخزنه كمستخدم حالي
    _currentUser = newUser;
    await _saveCurrentUser(newUser);

    return newUser;
  }

  /// تطبيق method التحقق من تسجيل الدخول
  @override
  Future<bool> isLoggedIn() async {
    // نرجع true لو في مستخدم حالي
    return _currentUser != null;
  }

  /// تطبيق method تسجيل الخروج
  @override
  Future<void> logout() async {
    // نحاكي تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));
    // نحذف بيانات المستخدم الحالي
    _currentUser = null;
    await _saveCurrentUser(null);
  }
}
