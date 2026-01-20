# البدء السريع 🚀

## المتطلبات
- Flutter 3.9.2 أو أحدث
- حساب Google (لـ Firebase)
- Android Studio أو VS Code

---

## ✅ الخطوات السريعة

### 1. تثبيت المكتبات
```bash
flutter pub get
```

### 2. إنشاء مشروع Firebase
1. اذهب إلى [console.firebase.google.com](https://console.firebase.google.com)
2. **Create New Project**
3. الاسم: `todo-app-bloc`
4. انتظر الإنشاء

### 3. ربط Android
1. في Firebase: **Project Settings**
2. **Add App** → **Android**
3. Package Name: `com.example.to_do_app_with_bloc`
4. حمّل `google-services.json`
5. ضع في `android/app/`

### 4. تحديث firebase_options.dart
من Firebase Console:
```dart
// Project Settings → google-services.json
apiKey: 'من الملف'
appId: 'من الملف'
messagingSenderId: 'من الملف'
projectId: 'من الملف'
storageBucket: 'من الملف'
```

### 5. تفعيل Firestore
- في Firebase: **Firestore Database**
- **Create Database** → Production Mode

### 6. تفعيل Authentication
- في Firebase: **Authentication**
- **Get Started** → فعّل **Email/Password**

### 7. تشغيل التطبيق
```bash
flutter run
```

---

## 🎬 اختبار التطبيق

**الخطوات**:
1. ستفتح شاشة التسجيل مباشرة
2. أدخل البيانات:
   ```
   الاسم الأول: أحمد
   الاسم الأخير: محمد
   البريد: ahmed@gmail.com
   كلمة السر: password123
   ```
3. انقر "إنشاء حساب"
4. ستظهر رسالة "تم التسجيل بنجاح" مع البيانات
5. انقر "اذهب للدخول"
6. سجل دخول بنفس البيانات
7. ستدخل لشاشة المهام

---

## 🔍 التحقق

**في Firebase Console**:
1. **Firestore Database**
2. **Collection**: `users`
3. يجب أن ترى المستخدم الجديد مع البيانات

---

## ⚠️ مشاكل شائعة

| المشكلة | الحل |
|--------|------|
| "Firebase not initialized" | تأكد من firebase_options.dart صحيح |
| "Google services not found" | ضع google-services.json في android/app/ |
| خطأ Build | `flutter clean` ثم `flutter pub get` |
| خطأ Connection | تأكد من الانترنت وإعدادات Firebase |

---

## 📞 تحتاج مساعدة؟

اقرأ الملفات التالية:
- `FIREBASE_SETUP_GUIDE_AR.md` - شرح تفصيلي
- `IMPLEMENTATION_SUMMARY_AR.md` - شرح التغييرات

