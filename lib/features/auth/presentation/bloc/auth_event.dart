// =====================================
// Auth Events - الأحداث الخاصة بالمصادقة
// =====================================

import 'package:equatable/equatable.dart';

/// Base class لكل الأحداث بتاع Auth
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event لما نضغط على زر تسجيل الدخول
/// بتحتوي على البيانات المدخلة (email و password)
class LoginEvent extends AuthEvent {
  final String email; // البريد الإلكتروني المدخل
  final String password; // كلمة السر المدخلة

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Event لما نضغط على زر التسجيل (الإنشاء)
/// بتحتوي على بيانات التسجيل الجديد
class RegisterEvent extends AuthEvent {
  final String email; // البريد الإلكتروني الجديد
  final String password; // كلمة السر الجديدة
  final String name; // اسم المستخدم الجديد

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

/// Event لما نضغط على زر تسجيل الخروج
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event لما نضغط على زر Google Sign In
class GoogleSignInEvent extends AuthEvent {
  const GoogleSignInEvent();
}

/// Event لما نضغط على زر Facebook Sign In
class FacebookSignInEvent extends AuthEvent {
  const FacebookSignInEvent();
}

/// Event بنستخدمه بـ startup التطبيق علشان نتحقق من حالة المستخدم
class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}
