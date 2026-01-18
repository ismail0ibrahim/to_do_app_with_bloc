// =====================================
// Auth BLoC - منطق تسجيل الدخول
// =====================================

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC هو اختصار Business Logic Component
/// دا هو المسؤول عن كل منطق المصادقة والتواصل بين UI والـ Repository
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // هنا بنخزن الـ Repository بتاعنا
  final AuthRepository authRepository;

  /// Constructor بيستقبل الـ Repository
  AuthBloc({required this.authRepository}) : super(const AuthInitialState()) {
    // هنا بنربط الأحداث بمعالجاتها
    // بكل مرة اللي في EventMap يحصل event، نروح للـ handler بتاعه

    // handler بتاع LoginEvent
    on<LoginEvent>(_onLoginEvent);

    // handler بتاع RegisterEvent
    on<RegisterEvent>(_onRegisterEvent);

    // handler بتاع LogoutEvent
    on<LogoutEvent>(_onLogoutEvent);

    // handler بتاع CheckAuthEvent
    on<CheckAuthEvent>(_onCheckAuthEvent);

    // handler بتاع GoogleSignInEvent
    on<GoogleSignInEvent>(_onGoogleSignInEvent);

    // handler بتاع FacebookSignInEvent
    on<FacebookSignInEvent>(_onFacebookSignInEvent);
  }

  /// معالج LoginEvent
  /// بتستقبل الـ event و Emitter بتستخدمه لإصدار States جديدة
  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      // أول حاجة، بنصدر LoadingState علشان نقول للـ UI إننا بنشتغل
      emit(const AuthLoadingState(message: 'جاري تسجيل الدخول...'));

      // بنستدعي الـ repository بتاعنا علشان نسجل دخول
      final user = await authRepository.login(event.email, event.password);

      // لو النتيجة نجحت، بنصدر SuccessState مع بيانات المستخدم
      emit(AuthSuccessState(user));
    } catch (e) {
      // لو حصل خطأ، بنصدر ErrorState مع رسالة الخطأ
      emit(AuthErrorState(e.toString()));
    }
  }

  /// معالج RegisterEvent
  /// نفس الفكرة بس للتسجيل الجديد
  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoadingState(message: 'جاري إنشاء الحساب...'));

      // بنستدعي الـ repository علشان نسجل مستخدم جديد
      final user = await authRepository.register(
        event.email,
        event.password,
        event.name,
      );

      // لو نجح، بنصدر SuccessState
      emit(AuthSuccessState(user));
    } catch (e) {
      // لو فيه خطأ (مثلاً البريد موجود بالفعل)
      emit(AuthErrorState(e.toString()));
    }
  }

  /// معالج LogoutEvent
  /// بتسجل خروج المستخدم
  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoadingState(message: 'جاري تسجيل الخروج...'));

      // بنستدعي logout من الـ repository
      await authRepository.logout();

      // لو نجح، بنصدر LoggedOutState
      emit(const AuthLoggedOutState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  /// معالج CheckAuthEvent
  /// بنستخدمه في بداية التطبيق للتحقق من حالة المستخدم
  Future<void> _onCheckAuthEvent(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // بنتحقق من هل المستخدم مسجل دخول ولا لا
      final isLoggedIn = await authRepository.isLoggedIn();

      if (isLoggedIn) {
        // لو نعم، نصدر AuthenticatedState
        // ملاحظة: هنا بافترض إننا عندنا طريقة للحصول على بيانات المستخدم
        // في التطبيقات الحقيقية، بنحفظ المستخدم في SharedPreferences أو Firebase
        emit(
          AuthAuthenticatedState(
            User(
              id: 'temp',
              firstName: 'Temp',
              lastName: 'User',
              email: 'temp@test.com',
              password: 'temp',
            ),
          ),
        );
      } else {
        // لو لا، نصدر UnauthenticatedState
        emit(const AuthUnauthenticatedState());
      }
    } catch (e) {
      emit(const AuthUnauthenticatedState());
    }
  }

  /// معالج GoogleSignInEvent
  /// بتسجل دخول المستخدم عبر Google
  Future<void> _onGoogleSignInEvent(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoadingState(message: 'جاري تسجيل الدخول عبر Google...'));

      // نتحقق أن Repository هي Firebase implementation
      // لو كانت؟ نستدعي loginWithGoogle
      if (authRepository.runtimeType.toString().contains('Firebase')) {
        // بما إن الـ Repository interface ما فيه loginWithGoogle
        // لازم نستخدم تحويل أمن (cast)
        final firebaseRepo = authRepository as dynamic;
        final user = await firebaseRepo.loginWithGoogle();
        emit(AuthSuccessState(user));
      } else {
        throw Exception('هذه الميزة متاحة فقط مع Firebase');
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  /// معالج FacebookSignInEvent
  /// بتسجل دخول المستخدم عبر Facebook
  Future<void> _onFacebookSignInEvent(
    FacebookSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(
        const AuthLoadingState(message: 'جاري تسجيل الدخول عبر Facebook...'),
      );

      // نتحقق أن Repository هي Firebase implementation
      if (authRepository.runtimeType.toString().contains('Firebase')) {
        final firebaseRepo = authRepository as dynamic;
        final user = await firebaseRepo.loginWithFacebook();
        emit(AuthSuccessState(user));
      } else {
        throw Exception('هذه الميزة متاحة فقط مع Firebase');
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
