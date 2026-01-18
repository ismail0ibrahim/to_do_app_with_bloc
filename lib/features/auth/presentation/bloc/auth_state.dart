// =====================================
// Auth States - حالات المصادقة
// =====================================

import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

/// Base class لكل حالات Auth
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية (قبل أي تفاعل)
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// حالة التحميل (بينما نرسل الطلب)
class AuthLoadingState extends AuthState {
  final String message; // رسالة تحميل اختيارية (مثل: "جاري التحقق...")

  const AuthLoadingState({this.message = 'جاري معالجة الطلب...'});

  @override
  List<Object?> get props => [message];
}

/// حالة النجاح (تسجيل الدخول/التسجيل نجح)
class AuthSuccessState extends AuthState {
  final User user; // المستخدم اللي دخل بنجاح

  const AuthSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

/// حالة الخطأ (حصل مشكلة)
class AuthErrorState extends AuthState {
  final String message; // رسالة الخطأ

  const AuthErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة تسجيل الخروج الناجح
class AuthLoggedOutState extends AuthState {
  const AuthLoggedOutState();
}

/// حالة المستخدم logged in (بنستخدمها بـ app startup)
class AuthAuthenticatedState extends AuthState {
  final User user; // المستخدم الحالي

  const AuthAuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

/// حالة المستخدم not logged in
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}
