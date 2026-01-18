// =====================================
// Firebase Auth Repository Implementation
// تطبيق مستودع المصادقة عبر Firebase
// =====================================

import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

/// تطبيق AuthRepository باستخدام Firebase
/// هذا يحل محل AuthRepositoryImpl السابق
class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  FirebaseAuthRepositoryImpl({FirebaseAuthService? firebaseAuthService})
    : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService();

  /// تسجيل الدخول بـ Email و Password
  @override
  Future<User> login(String email, String password) async {
    return await _firebaseAuthService.loginWithEmail(email, password);
  }

  /// التسجيل الجديد بـ Email و Password
  @override
  Future<User> register(String email, String password, String name) async {
    return await _firebaseAuthService.registerWithEmail(email, password, name);
  }

  /// تسجيل الدخول عن طريق Google
  Future<User> loginWithGoogle() async {
    return await _firebaseAuthService.loginWithGoogle();
  }

  /// تسجيل الدخول عن طريق Facebook
  Future<User> loginWithFacebook() async {
    return await _firebaseAuthService.loginWithFacebook();
  }

  /// التحقق من حالة المستخدم الحالي
  @override
  Future<bool> isLoggedIn() async {
    return await _firebaseAuthService.isLoggedIn();
  }

  /// الحصول على المستخدم الحالي
  Future<User?> getCurrentUser() async {
    return await _firebaseAuthService.getCurrentUser();
  }

  /// تسجيل الخروج
  @override
  Future<void> logout() async {
    return await _firebaseAuthService.logout();
  }
}
