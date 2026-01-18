// =====================================
// Firebase Auth Service (محلي)
// =====================================

import '../models/user_model.dart';

/// خدمة محلية للمصادقة
/// بتتعامل مع تسجيل الدخول والتسجيل بدون الحاجة لـ Firebase
class FirebaseAuthService {
  // قائمة بيانات وهمية بتمثل قاعدة البيانات
  static final List<User> _users = [
    User(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      password: 'password123',
    ),
  ];

  /// تسجيل الدخول بـ Email و Password
  Future<User> loginWithEmail(String email, String password) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 1));

      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      return user;
    } catch (e) {
      throw Exception('بيانات تسجيل الدخول غير صحيحة');
    }
  }

  /// التسجيل الجديد بـ Email و Password
  Future<User> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 1));

      // التحقق من أن البريد غير موجود
      final exists = _users.any((user) => user.email == email);
      if (exists) {
        throw Exception('البريد الإلكتروني مسجل بالفعل');
      }

      // إنشاء مستخدم جديد
      final nameParts = name.split(' ');
      final newUser = User(
        id: DateTime.now().toString(),
        firstName: nameParts.isNotEmpty ? nameParts[0] : '',
        lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        email: email,
        password: password,
      );

      _users.add(newUser);
      return newUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// تسجيل الدخول عن طريق Google
  Future<User> loginWithGoogle() async {
    throw Exception(
      'هذه الميزة متاحة فقط مع Firebase - يرجى استخدام البريد الإلكتروني',
    );
  }

  /// تسجيل الدخول عن طريق Facebook
  Future<User> loginWithFacebook() async {
    throw Exception(
      'هذه الميزة متاحة فقط مع Firebase - يرجى استخدام البريد الإلكتروني',
    );
  }

  /// التحقق من حالة المستخدم الحالي
  Future<bool> isLoggedIn() async {
    return true; // المستخدم يعتبر مسجل دخول دائماً في المستودع المحلي
  }

  /// الحصول على المستخدم الحالي
  Future<User?> getCurrentUser() async {
    if (_users.isNotEmpty) {
      return _users.first;
    }
    return null;
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    // محاكاة تسجيل الخروج
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
