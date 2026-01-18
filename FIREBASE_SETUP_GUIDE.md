# دليل إعداد Firebase Authentication

## 📱 خطوات الإعداد الشاملة

### 1️⃣ إنشاء Firebase Project

#### أ) الذهاب لـ Firebase Console
```
https://console.firebase.google.com/
```

#### ب) إنشاء مشروع جديد
- اضغط "Create a new project"
- اختر اسم المشروع (مثلاً: to_do_app)
- اتبع الخطوات

---

### 2️⃣ تشغيل FlutterFire CLI

#### تثبيت FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

#### تشغيل الأمر:
```bash
flutterfire configure
```

هذا الأمر سيقوم بـ:
- اختيار Platform (Android / iOS / Web)
- ربط التطبيق بـ Firebase Project
- توليد `firebase_options.dart` تلقائياً

---

### 3️⃣ تفعيل Google Sign-In

#### في Firebase Console:
1. انتقل للمشروع
2. اذهب إلى Authentication → Sign-in method
3. فعّل "Google"
4. اختر "Default support email"
5. اضغط Save

---

### 4️⃣ تفعيل Facebook Login

#### في Facebook Developers:
1. انتقل إلى https://developers.facebook.com/
2. أنشئ حساب (إذا لم يكن لديك)
3. أنشئ تطبيق جديد
4. اختر "Consumer" كنوع التطبيق
5. اضغط "Facebook Login"

#### في Firebase Console:
1. اذهب إلى Authentication → Sign-in method
2. فعّل "Facebook"
3. أضف Facebook App ID و App Secret
4. أضف Authorized redirect URIs

#### في Facebook App:
1. اذهب إلى Settings → Basic
2. أضف Platform → Android
3. أضف Package Name و Key Hash
4. أضف Platform → iOS
5. أضف Bundle ID

---

### 5️⃣ إعدادات Android

#### ملف `android/app/build.gradle`:
```gradle
android {
    // ... إعدادات أخرى

    defaultConfig {
        // ...
        multiDexEnabled true
    }
}

dependencies {
    // Firebase
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    
    // Google Sign-In
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

#### ملف `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest ... >
    <!-- Facebook Login -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Google Sign-In -->
    <uses-permission android:name="android.permission.GET_ACCOUNTS" />
</manifest>
```

---

### 6️⃣ إعدادات iOS

#### ملف `ios/Podfile`:
تأكد من أن iOS deployment target هو 11.0 أو أعلى:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
      ]
    end
  end
end
```

#### ملف `ios/Runner/Info.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ...>
<plist version="1.0">
<dict>
    <!-- Google Sign-In -->
    <key>GIDClientID</key>
    <string>YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com</string>
    
    <!-- Facebook Login -->
    <key>FacebookAppID</key>
    <string>YOUR_FACEBOOK_APP_ID</string>
    <key>FacebookDisplayName</key>
    <string>Your App Name</string>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>fb YOUR_FACEBOOK_APP_ID</string>
                <string>com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

---

### 7️⃣ تثبيت Dependencies

```bash
flutter pub get
```

---

### 8️⃣ تشغيل التطبيق

#### حذف الـ build القديم:
```bash
flutter clean
```

#### التشغيل:
```bash
flutter run
```

---

## 🔑 كيفية الاستخدام

### تسجيل الدخول بـ Email و Password:
```dart
final email = "user@example.com";
final password = "password123";

context.read<AuthBloc>().add(
  LoginEvent(email: email, password: password),
);
```

### تسجيل الدخول بـ Google:
```dart
context.read<AuthBloc>().add(
  const GoogleSignInEvent(),
);
```

### تسجيل الدخول بـ Facebook:
```dart
context.read<AuthBloc>().add(
  const FacebookSignInEvent(),
);
```

### التسجيل الجديد:
```dart
context.read<AuthBloc>().add(
  RegisterEvent(
    email: "newuser@example.com",
    password: "password123",
    name: "User Name",
  ),
);
```

### الاستماع للـ States:
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccessState) {
      // تسجيل دخول ناجح
      print('User: ${state.user.email}');
    }
    if (state is AuthErrorState) {
      // خطأ
      print('Error: ${state.message}');
    }
  },
  child: Container(),
)
```

---

## 🛡️ نصائح الأمان

### 1. تخزين آمن:
- استخدم `flutter_secure_storage` لتخزين sensitive data
- لا تخزن passwords بـ plaintext

### 2. HTTPS فقط:
- تأكد من استخدام HTTPS في جميع API calls

### 3. Validation:
- تحقق من صحة البيانات دائماً قبل الإرسال

### 4. Error Handling:
- أظهر رسائل خطأ عامة للمستخدم
- لا تكشف تفاصيل الأخطاء الحساسة

---

## 🐛 استكشاف الأخطاء

### خطأ: "Initialization error"
**الحل**: تأكد من استدعاء `Firebase.initializeApp()` في `main()`

### خطأ: "Google Sign-In failed"
**الحل**: تأكد من:
- تفعيل Google Sign-In في Firebase Console
- صحة Google Client ID في iOS
- تثبيت Google Play Services على الجهاز

### خطأ: "Facebook Login failed"
**الحل**: تأكد من:
- تفعيل Facebook في Firebase Console
- صحة Facebook App ID
- صحة URL Schemes في iOS و Intent Filter في Android

---

## 📚 موارد إضافية

- [Firebase Documentation](https://firebase.flutter.dev/)
- [Google Sign-In Plugin](https://pub.dev/packages/google_sign_in)
- [Facebook Flutter SDK](https://pub.dev/packages/flutter_facebook_auth)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

---

## ✅ Checklist قبل النشر

- [ ] تفعيل Google Sign-In في Firebase
- [ ] تفعيل Facebook Login في Firebase
- [ ] إضافة Firebase credentials إلى التطبيق
- [ ] اختبار التسجيل بـ Email و Password
- [ ] اختبار Google Sign-In
- [ ] اختبار Facebook Login
- [ ] التحقق من رسائل الخطأ
- [ ] اختبار التسجيل الجديد
- [ ] اختبار تسجيل الخروج
