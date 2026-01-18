// =====================================
// Auth Repository - مستودع المصادقة
// =====================================

import '../../data/models/user_model.dart';

/// Abstract Repository بيحدد واجهة المصادقة
/// النقطة الفاصلة بين Business Logic والـ Data
abstract class AuthRepository {
  /// Method بتسجل دخول المستخدم
  /// تاخد email وpassword
  /// ترجع User object أو ترمي exception
  Future<User> login(String email, String password);

  /// Method بتسجل مستخدم جديد
  /// ترجع User object أو تطلع خطأ
  Future<User> register(String email, String password, String name);

  /// Method بتتحقق من حالة تسجيل الدخول الحالية
  /// ترجع true لو المستخدم logged in، false بخلاف ذلك
  Future<bool> isLoggedIn();

  /// Method بتسجل خروج المستخدم
  Future<void> logout();
}
