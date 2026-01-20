# دليل تكوين Firebase مع التطبيق 🚀

## المحتويات
1. [ما تم إنجازه](#ما-تم-إنجازه)
2. [خطوات الإعداد](#خطوات-الإعداد)
3. [شرح التدفق](#شرح-التدفق)
4. [الملفات المُعدَّلة](#الملفات-المُعدَّلة)

---

## ✅ ما تم إنجازه

### 1. **إضافة مكتبات Firebase**
تم إضافة المكتبات التالية إلى `pubspec.yaml`:
- `firebase_core: ^2.24.2` - إطار Firebase الأساسي
- `firebase_auth: ^4.15.3` - مصادقة Firebase
- `cloud_firestore: ^4.14.0` - قاعدة بيانات Firestore

### 2. **تحديث User Model**
- إضافة حقل `createdAt` لتتبع تاريخ إنشاء الحساب
- إضافة `Equatable` لمقارنة المستخدمين بسهولة

### 3. **تحديث Repository للعمل مع Firebase**
تم تحويل `AuthRepositoryImpl` للعمل مع Firebase:
- استخدام `firebase_auth` للمصادقة
- حفظ بيانات المستخدم على `Cloud Firestore`
- الحفاظ على النسخة المحلية عبر `SharedPreferences`

### 4. **تحديث شاشة التسجيل**
- عرض رسالة نجاح مع بيانات المستخدم (الاسم والبريد)
- توجيه مباشر لشاشة تسجيل الدخول
- Dialog جميل يعرض البيانات المسجلة

### 5. **تحديث main.dart**
- توجيه المستخدم الجديد مباشرة لشاشة التسجيل
- إضافة Firebase initialization
- إضافة روابط لشاشات التطبيق

---

## 📋 خطوات الإعداد

### الخطوة 1: تثبيت المكتبات
```bash
cd d:\to_do_app_with_bloc
flutter pub get
```

### الخطوة 2: إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على **Create a New Project**
3. أدخل اسم المشروع (مثلاً: "todo-app-bloc")
4. أتمم خطوات الإنشاء

### الخطوة 3: تكوين Android
1. في Firebase Console، اذهب إلى **Project Settings**
2. انقر على **Add App** واختر **Android**
3. أدخل معلومات التطبيق:
   - **Package name**: `com.example.to_do_app_with_bloc`
   - **App nickname**: `To Do App`
4. انقر **Register app**
5. حمّل `google-services.json`
6. ضع الملف في `android/app/`
7. اتبع التعليمات لتحديث ملفات Android

### الخطوة 4: تكوين iOS (اختياري)
1. في Firebase Console، انقر على **Add App** واختر **iOS**
2. أدخل معلومات التطبيق:
   - **iOS bundle ID**: `com.example.toDoAppWithBloc`
3. حمّل `GoogleService-Info.plist`
4. ضع الملف في `ios/Runner/`

### الخطوة 5: تحديث firebase_options.dart
استبدل القيم الوهمية في `lib/firebase_options.dart` بالقيم الفعلية من Firebase:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',           // من Firebase Console
  appId: 'YOUR_ACTUAL_APP_ID',             // من firebase_options.dart
  messagingSenderId: 'YOUR_SENDER_ID',     // من firebase_options.dart
  projectId: 'your-project-id',            // من Firebase Console
  storageBucket: 'your-project.appspot.com', // من Firebase Console
);
```

### الخطوة 6: تفعيل Firestore
1. في Firebase Console، اذهب إلى **Firestore Database**
2. انقر **Create Database**
3. ابدأ بـ **Production mode** (أو Test mode للاختبار)
4. اختر منطقة قريبة منك

### الخطوة 7: تفعيل Authentication
1. في Firebase Console، اذهب إلى **Authentication**
2. انقر على **Get Started**
3. فعّل **Email/Password**

### الخطوة 8: إنشاء Firestore Collection
في Firestore، أنشئ Collection جديدة:
```
Collection Name: users
Document ID: auto-generated
Fields:
- id: string (Firebase UID)
- firstName: string
- lastName: string
- email: string
- password: string
- createdAt: timestamp
```

---

## 🔄 شرح التدفق

### عند المستخدم الجديد:
```
البدء
    ↓
شاشة التسجيل (RegisterScreen)
    ↓
أدخل: الاسم الأول، الاسم الأخير، البريد، كلمة السر
    ↓
انقر "إنشاء حساب"
    ↓
Bloc ← Repository ← Firebase Auth
    ↓
(عند النجاح)
حفظ على Firestore + SharedPreferences
    ↓
Dialog: "تم التسجيل بنجاح"
عرض: الاسم والبريد
    ↓
انقر "اذهب للدخول"
    ↓
شاشة تسجيل الدخول (LoginScreen)
```

### عند المستخدم الموجود:
```
شاشة تسجيل الدخول
    ↓
أدخل: البريد، كلمة السر
    ↓
انقر "تسجيل الدخول"
    ↓
Bloc ← Repository ← Firebase Auth
    ↓
(عند النجاح)
الحصول على البيانات من Firestore
    ↓
عرض شاشة المهام (TodoScreen)
```

---

## 📁 الملفات المُعدَّلة

### 1. **pubspec.yaml**
- ✅ إضافة Firebase packages

### 2. **lib/main.dart**
- ✅ استيراد Firebase
- ✅ تهيئة Firebase
- ✅ توجيه المستخدم الجديد لـ RegisterScreen
- ✅ إضافة routes

### 3. **lib/firebase_options.dart**
- ✅ إعدادات Firebase لجميع المنصات
- ✅ placeholder للقيم الفعلية

### 4. **lib/features/auth/data/models/user_model.dart**
- ✅ إضافة `Equatable`
- ✅ إضافة `createdAt`
- ✅ تحديث `toJson()` و `fromJson()`

### 5. **lib/features/auth/data/repositories/auth_repository_impl.dart**
- ✅ استيراد Firebase packages
- ✅ تحديث `login()` للعمل مع Firebase
- ✅ تحديث `register()` للعمل مع Firebase
- ✅ إضافة `registerWithDetails()`
- ✅ حفظ البيانات على Firestore

### 6. **lib/features/auth/presentation/screens/register_screen.dart**
- ✅ تحسين Dialog النجاح
- ✅ عرض بيانات المستخدم
- ✅ توجيه للـ Login بشكل صحيح

### 7. **lib/features/auth/presentation/screens/login_screen.dart**
- ✅ بدون تغيير (يعمل مع Repository المحدث)

---

## 🧪 الاختبار

### 1. تشغيل التطبيق
```bash
flutter run
```

### 2. اختبار التسجيل الجديد
- افتح التطبيق (ستفتح مباشرة شاشة التسجيل)
- أدخل بيانات:
  - الاسم الأول: أحمد
  - الاسم الأخير: محمد
  - البريد: ahmed@example.com
  - كلمة السر: password123
- انقر "إنشاء حساب"
- تحقق من:
  - ✅ ظهور Dialog النجاح
  - ✅ عرض البيانات بشكل صحيح
  - ✅ الانتقال للـ Login عند النقر على "اذهب للدخول"

### 3. اختبار تسجيل الدخول
- استخدم البيانات المسجلة حديثاً
- تحقق من الانتقال لشاشة المهام

### 4. التحقق من Firestore
- اذهب إلى Firebase Console
- تحقق من ظهور المستخدم الجديد في Collection users

---

## ⚠️ ملاحظات مهمة

1. **Security Rules**: احرص على تحديث Firestore Security Rules:
```javascript
match /users/{document=**} {
  allow create: if request.auth != null;
  allow read: if request.auth.uid == resource.data.id;
  allow update: if request.auth.uid == resource.data.id;
  allow delete: if request.auth.uid == resource.data.id;
}
```

2. **كلمات السر**: لا تخزن كلمات السر في Firestore (Firebase Auth يتعامل معها بشكل آمن)

3. **API Keys**: لا تنشر API Keys الفعلية - استخدم متغيرات البيئة

4. **Testing**: في بدايات التطوير، استخدم Firebase Emulator

---

## 🎯 الخطوات التالية

- [ ] إضافة Validation أقوى
- [ ] إضافة password reset
- [ ] إضافة social login (Google, Facebook)
- [ ] إضافة email verification
- [ ] تحسين error handling
- [ ] إضافة tests

---

## 📞 للمزيد من المساعدة

- 📖 [Firebase Documentation](https://firebase.flutter.dev/)
- 🔍 [Flutter Firebase Docs](https://pub.dev/packages/firebase_core)
- 🗂️ [Firestore Documentation](https://firebase.google.com/docs/firestore)

