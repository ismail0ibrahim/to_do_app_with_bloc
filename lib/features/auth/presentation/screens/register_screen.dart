// =====================================
// Register Screen - شاشة التسجيل الجديد
// =====================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';

/// شاشة التسجيل الجديد
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // التحقق من تطابق كلمات السر
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('كلمات السر غير متطابقة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // إرسال حدث التسجيل مع الاسم الأول والأخير مباشرة
      context.read<AuthBloc>().add(
        RegisterEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: '${_firstNameController.text} ${_lastNameController.text}',
        ),
      );
    }
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
                  const SizedBox(height: 30),

                  // App Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // العنوان الرئيسي
                  Text(
                    'إنشاء حساب جديد',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // النص الفرعي
                  Text(
                    'أنشئ حسابك للوصول إلى مهامك',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // الاسم الأول
                  CustomTextField(
                    controller: _firstNameController,
                    label: 'الاسم الأول',
                    hint: 'أدخل اسمك الأول',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'الاسم الأول مطلوب';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // الاسم الأخير
                  CustomTextField(
                    controller: _lastNameController,
                    label: 'الاسم الأخير',
                    hint: 'أدخل اسمك الأخير',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'الاسم الأخير مطلوب';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // البريد الإلكتروني
                  CustomTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'أدخل بريدك الإلكتروني',
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'البريد الإلكتروني مطلوب';
                      }
                      if (!value!.contains('@')) {
                        return 'أدخل بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // كلمة السر
                  CustomTextField(
                    controller: _passwordController,
                    label: 'كلمة السر',
                    hint: 'أدخل كلمة سرك',
                    prefixIcon: Icons.lock,
                    isPassword: true,
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

                  const SizedBox(height: 16),

                  // تأكيد كلمة السر
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'تأكيد كلمة السر',
                    hint: 'أدخل كلمة سرك مرة أخرى',
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'تأكيد كلمة السر مطلوب';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // زر التسجيل
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoadingState;

                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _handleRegister,
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
                                  'إنشاء حساب',
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

                  const SizedBox(height: 16),

                  // عرض الأخطاء والنجاح
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                      if (state is AuthSuccessState) {
                        // عرض رسالة النجاح مع بيانات المستخدم
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('✓ تم التسجيل بنجاح'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'مرحباً ${state.user.fullName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'البريد: ${state.user.email}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'الرجاء تسجيل الدخول بحسابك الجديد',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // إغلاق الـ Dialog
                                  // الانتقال لشاشة اللوجين
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'اذهب للدخول',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const SizedBox(),
                  ),

                  const SizedBox(height: 16),

                  // رابط العودة لشاشة التسجيل الدخول
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟ ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
