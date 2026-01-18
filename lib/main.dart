import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/todo/presentation/bloc/task_bloc.dart';
import 'features/todo/presentation/screen/todo_screen.dart';
// استيراد Auth Feature
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة AuthRepositoryImpl قبل تشغيل التطبيق
  final authRepository = AuthRepositoryImpl();
  await Future.delayed(
    const Duration(milliseconds: 500),
  ); // انتظر تحميل البيانات

  runApp(MyApp(authRepository: authRepository));
}

// دي الكلاس الرئيسية اللي بتبني التطبيق
class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider دي علشان لو عندك اكتر من Bloc
    // هنا احنا بنوفر TaskBloc و AuthBloc للتطبيق كله
    return MultiBlocProvider(
      providers: [
        // BlocProvider بيعمل create للـ AuthBloc (لتسجيل الدخول)
        // الآن بنستخدم AuthRepositoryImpl (بدون Firebase)
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        // BlocProvider بيعمل create للـ TaskBloc
        BlocProvider<TaskBloc>(create: (_) => TaskBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // بيشيل Banner الأحمر بتاع Debug
        title: 'To Do App with Bloc', // اسم التطبيق
        theme: ThemeData(primarySwatch: Colors.blue), // الثيم الأساسي
        // الآن الشاشة الأولى هي LoginScreen بدل TodoScreen
        home: const LoginScreen(), // شاشة اللوجن هي الشاشة الأولى
        // إضافة الروابط
        routes: {'/home': (context) => const TodoScreen()},
      ),
    );
  }
}
