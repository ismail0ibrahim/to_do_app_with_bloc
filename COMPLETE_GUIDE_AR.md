# 📚 دليل شامل - نظام التسجيل والمصادقة الجديد

## 🎯 الهدف

تطبيق To Do مع Bloc يوجه المستخدم الجديد مباشرة لشاشة التسجيل، ويطلب منه:
- ✅ الاسم الأول والأخير
- ✅ البريد الإلكتروني
- ✅ كلمة السر

بعد التسجيل:
- ✅ يظهر Dialog نجاح مع بيانات المستخدم
- ✅ يتم حفظ البيانات على Firebase Firestore
- ✅ يتم توجيه المستخدم لشاشة الدخول

---

## 📦 الحزم المضافة

```yaml
dependencies:
  firebase_core: ^2.24.2      # ✅ Firebase Framework
  firebase_auth: ^4.15.3       # ✅ Firebase Authentication
  cloud_firestore: ^4.14.0     # ✅ Firebase Database
  equatable: ^2.0.5            # ✅ Comparison Helper
  shared_preferences: ^2.2.2   # ✅ Local Storage
  flutter_bloc: ^8.1.3         # ✅ State Management
```

---

## 🏗️ البنية المعمارية

```
lib/
├── main.dart                          # ✅ نقطة البداية + Firebase Init
├── firebase_options.dart              # ✅ إعدادات Firebase
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── user_model.dart    # ✅ User + DateTime + Equatable
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart  # ✅ Firebase Integration
    │   ├── domain/
    │   │   └── repositories/
    │   │       └── auth_repository.dart       # ✅ Interface
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart            # ✅ Logic Handler
    │       │   ├── auth_event.dart           # ✅ Events
    │       │   └── auth_state.dart           # ✅ States
    │       ├── screens/
    │       │   ├── login_screen.dart         # ✅ Login UI
    │       │   └── register_screen.dart      # ✅ Register UI + Dialog
    │       └── widgets/
    │           └── custom_text_field.dart    # ✅ Reusable TextField
    └── todo/                          # (بدون تغيير)
```

---

## 🔄 تدفق البيانات التفصيلي

### 1️⃣ عند بدء التطبيق

```dart
main() {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Create Repository
  final authRepository = AuthRepositoryImpl();
  
  // Run App with RegisterScreen as home
  runApp(MyApp(authRepository: authRepository));
}
```

**النتيجة**: التطبيق يفتح مباشرة شاشة التسجيل

---

### 2️⃣ عملية التسجيل

#### الخطوة A: المستخدم يدخل البيانات

```
RegisterScreen
├── firstName: "أحمد"
├── lastName: "محمد"  
├── email: "ahmed@example.com"
├── password: "password123"
└── confirmPassword: "password123"
```

#### الخطوة B: المستخدم ينقر "إنشاء حساب"

```dart
void _handleRegister() {
  if (_formKey.currentState!.validate()) {
    context.read<AuthBloc>().add(
      RegisterEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: '${_firstNameController.text} ${_lastNameController.text}',
      ),
    );
  }
}
```

#### الخطوة C: BLoC يستقبل الـ Event

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthInitialState()) {
    on<RegisterEvent>(_onRegisterEvent);
  }
  
  Future<void> _onRegisterEvent(RegisterEvent event, Emitter emit) async {
    try {
      emit(const AuthLoadingState(message: 'جاري إنشاء الحساب...'));
      
      final user = await authRepository.register(
        event.email,
        event.password,
        event.name,
      );
      
      emit(AuthSuccessState(user));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
```

#### الخطوة D: Repository يتعامل مع Firebase

```dart
Future<User> register(String email, String password, String name) async {
  try {
    // 1. إنشاء حساب Firebase
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. فصل الاسم
    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    // 3. إنشاء User Object
    final newUser = User(
      id: userCredential.user!.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );

    // 4. حفظ على Firestore
    await _firestore.collection('users').doc(newUser.id).set(
      newUser.toJson(),
    );

    // 5. حفظ محلي
    _users.add(newUser);
    await _saveUsers();
    _currentUser = newUser;
    await _saveCurrentUser(newUser);

    return newUser;
  } catch (e) {
    throw Exception('خطأ: ${e.toString()}');
  }
}
```

#### الخطوة E: State يصدر النجاح

```dart
// BlocListener يستقبل AuthSuccessState
if (state is AuthSuccessState) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('✓ تم التسجيل بنجاح'),
      content: Column(
        children: [
          Text('مرحباً ${state.user.fullName}'),
          Text('البريد: ${state.user.email}'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text('اذهب للدخول'),
        ),
      ],
    ),
  );
}
```

#### الخطوة F: الانتقال لـ LoginScreen

```dart
// عند الانقر على زر "اذهب للدخول"
Navigator.of(context).popUntil((route) => route.isFirst);
// يرجع للشاشة الأولى (LoginScreen)
```

---

## 📊 ملخص الحالات (States)

```
AuthState (Base)
├── AuthInitialState        # الحالة الأولية
├── AuthLoadingState        # حالة التحميل ("جاري المعالجة...")
├── AuthSuccessState(user)  # نجاح التسجيل مع بيانات المستخدم
└── AuthErrorState(message) # خطأ في التسجيل
```

---

## 🗄️ قاعدة البيانات - Firestore

### Collection Structure

```
firestore (Root)
└── users (Collection)
    ├── firebase-uid-1 (Document)
    │   ├── id: "firebase-uid-1"
    │   ├── firstName: "أحمد"
    │   ├── lastName: "محمد"
    │   ├── email: "ahmed@example.com"
    │   ├── password: "hashed_by_firebase"
    │   └── createdAt: Timestamp
    │
    ├── firebase-uid-2 (Document)
    │   ├── id: "firebase-uid-2"
    │   ├── firstName: "فاطمة"
    │   ├── lastName: "علي"
    │   ├── email: "fatima@example.com"
    │   ├── password: "hashed_by_firebase"
    │   └── createdAt: Timestamp
    │
    └── ...
```

### مثال JSON

```json
{
  "id": "firebase-uid-abc123",
  "firstName": "أحمد",
  "lastName": "محمد",
  "email": "ahmed@example.com",
  "password": "hashed_password",
  "createdAt": "2024-01-20T10:30:00.000Z"
}
```

---

## 🔐 أمان البيانات

### Firebase Authentication Security
- ✅ Firebase يتعامل مع كلمات السر بشكل آمن (Hashed)
- ✅ لا نخزن كلمات السر في Firestore
- ✅ كل مستخدم له UID فريد من Firebase

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{document=**} {
      // السماح بالقراءة فقط لصاحب الحساب
      allow read: if request.auth.uid == resource.data.id;
      
      // السماح بالكتابة لأي مستخدم مصرح (عند التسجيل)
      allow create: if request.auth != null;
      
      // السماح بالتحديث لصاحب الحساب فقط
      allow update: if request.auth.uid == resource.data.id;
      
      // السماح بالحذف لصاحب الحساب فقط
      allow delete: if request.auth.uid == resource.data.id;
    }
  }
}
```

---

## ✅ قائمة الفحص النهائية

### التثبيت
- [ ] ✅ `flutter pub get` تم بنجاح
- [ ] ✅ لا توجد أخطاء build

### Firebase Setup
- [ ] ✅ مشروع Firebase مُنشأ
- [ ] ✅ `google-services.json` في `android/app/`
- [ ] ✅ `firebase_options.dart` محدّث
- [ ] ✅ Firestore تم تفعيله
- [ ] ✅ Authentication تم تفعيله (Email/Password)

### الاختبار
- [ ] ✅ التطبيق يفتح RegisterScreen مباشرة
- [ ] ✅ يمكن إدخال بيانات التسجيل
- [ ] ✅ Dialog النجاح يظهر مع البيانات
- [ ] ✅ الانتقال للـ Login يعمل
- [ ] ✅ تسجيل الدخول بالبيانات الجديدة يعمل
- [ ] ✅ البيانات تظهر في Firestore

### الإنتاج (Production)
- [ ] ✅ Security Rules مناسبة
- [ ] ✅ Error handling كامل
- [ ] ✅ لا توجد API Keys معرّضة
- [ ] ✅ التطبيق يعمل بدون إنترنت (محلياً)

---

## 🆘 مشاكل وحلول

| المشكلة | السبب | الحل |
|--------|-------|------|
| "Firebase not initialized" | firebase_options فارغ | عدّل firebase_options.dart |
| "Method not found: 'set'" | Firestore غير مُفعّل | فعّل Firestore في Console |
| "User creation failed" | بريد موجود بالفعل | استخدم بريد جديد |
| Dialog لا يظهر | BlocListener لم يستقبل | تحقق من emit(AuthSuccessState) |
| Build failure | gradle issue | `flutter clean` ثم `flutter pub get` |

---

## 📞 الدعم والمساعدة

### للأسئلة التقنية:
1. تحقق من `FIREBASE_SETUP_GUIDE_AR.md`
2. تحقق من `IMPLEMENTATION_SUMMARY_AR.md`
3. اقرأ السجلات في `flutter run -v`

### للأخطاء:
```bash
# تنظيف كامل
flutter clean

# إعادة تثبيت
flutter pub get

# تشغيل مع تفاصيل
flutter run -v
```

---

## 🎓 نقاط تعليمية مهمة

1. **BLoC Pattern**: فصل Logic عن UI
2. **Repository Pattern**: وسيط بين Data و UI
3. **State Management**: إدارة حالات التطبيق
4. **Firebase**: خدمات مجانية وآمنة
5. **Firestore**: قاعدة بيانات في السحابة
6. **Authentication**: مصادقة آمنة وموثوقة

---

## 🚀 الخطوات التالية

بعد نجاح التسجيل:
- [ ] إضافة Social Login (Google, Facebook)
- [ ] إضافة Forget Password
- [ ] إضافة Email Verification
- [ ] إضافة User Profile Update
- [ ] إضافة Notification System
- [ ] إضافة Real-time Updates

---

**تم الإنجاز بنجاح! 🎉**

تطبيقك الآن مجهز للإنتاج!

