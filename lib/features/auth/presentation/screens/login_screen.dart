// =====================================
// Login Screen - شاشة تسجيل الدخول
// =====================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';

/// شاشة تسجيل الدخول
/// هنا نظهر form بتاع تسجيل الدخول وبنتعامل مع أحداث BLoC
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers بتاع الـ Text Fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Global key بتاع الـ Form علشان نتحقق من البيانات قبل الإرسال
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // من المهم جداً إننا نحرر الـ Controllers لما نخرج من الشاشة
    // علشان ما تحصل memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ========================
                  // الجزء العلوي - Logo والعنوان
                  // ========================
                  const SizedBox(height: 40),

                  // App Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // العنوان الرئيسي
                  Text(
                    'مرحباً بك',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // النص الفرعي
                  Text(
                    'سجل دخولك للوصول إلى مهامك',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ========================
                  // حقول الإدخال
                  // ========================

                  // حقل البريد الإلكتروني
                  CustomTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'أدخل بريدك الإلكتروني',
                    prefixIcon: Icons.email,
                    validator: (value) {
                      // التحقق من أن الحقل ممتلئ
                      if (value?.isEmpty ?? true) {
                        return 'البريد الإلكتروني مطلوب';
                      }
                      // التحقق من صيغة البريد الإلكتروني
                      if (!value!.contains('@')) {
                        return 'أدخل بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // حقل كلمة السر
                  CustomTextField(
                    controller: _passwordController,
                    label: 'كلمة السر',
                    hint: 'أدخل كلمة سرك',
                    prefixIcon: Icons.lock,
                    isPassword: true, // هذا يخفي النص
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'كلمة السر مطلوبة';
                      }
                      if (value!.length < 6) {
                        return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ========================
                  // زر تسجيل الدخول
                  // ========================
                  // BlocBuilder بيستمع للـ AuthBloc
                  // ويعيد بناء الـ Widget كل ما الـ State يتغير
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      // بننشئ variable بنستخدمه بـ الزر
                      final isLoading = state is AuthLoadingState;

                      return SizedBox(
                        width: double.infinity, // الزر يأخد كل العرض المتاح
                        height: 56,
                        child: ElevatedButton(
                          // بنعطل الزر لو بنحمل (منع الضغط المتكرر)
                          onPressed: isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            disabledBackgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ========================
                  // عرض الأخطاء
                  // ========================
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      // لما يحصل خطأ، نظهر SnackBar
                      if (state is AuthErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      // لما يحصل نجاح، بننتقل للشاشة الرئيسية
                      if (state is AuthSuccessState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تسجيل الدخول بنجاح'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // الانتقال لشاشة TodoScreen
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/home', (route) => false);
                        });
                      }
                    },
                    child: const SizedBox(),
                  ),

                  const SizedBox(height: 24),

                  // ========================
                  // رابط التسجيل الجديد
                  // ========================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب؟ ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // هنا بننتقل لشاشة التسجيل الجديدة
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const RegisterScreen(),
                          //   ),
                          // );
                          // الانتقال لشاشة التسجيل الجديد
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'سجل الآن',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // للاختبار السريع - بيانات تجريبية
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'بيانات تجريبية:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'البريد: test@example.com',
                          style: TextStyle(fontSize: 11),
                        ),
                        Text(
                          'كلمة السر: password123',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Method بتتعامل مع الضغط على زر تسجيل الدخول
  void _handleLogin() {
    // أولاً بنتحقق من أن البيانات صحيحة
    if (_formKey.currentState!.validate()) {
      // لو صحيح، بنصدر LoginEvent للـ BLoC
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}
