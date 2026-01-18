# 🔑 تعديل Firebase Credentials يدوياً

## 📋 خطوات الحصول على البيانات

### 1️⃣ الذهاب لـ Firebase Console

```
https://console.firebase.google.com/
```

---

### 2️⃣ إنشاء Firebase Project

1. اضغط **Create a new project**
2. اسم المشروع: `to-do-app`
3. اختر الدول (يفضل قريبة منك)
4. اضغط **Create project**

---

### 3️⃣ إضافة Android App

#### الخطوة 1: إضافة التطبيق
1. في Dashboard، اضغط **Add app** (رمز Android)
2. اكتب اسم الحزمة:
   ```
   com.example.to_do_app_with_bloc
   ```
3. اضغط **Register app**

#### الخطوة 2: تحميل google-services.json
1. ستجد زر **Download google-services.json**
2. احفظ الملف في:
   ```
   android/app/
   ```
3. اضغط **Next** حتى تنتهي

#### الخطوة 3: نسخ البيانات
```
من Project Settings → Service Accounts
نسخ:
- API Key
- App ID
- Messaging Sender ID
- Project ID
- Storage Bucket
```

---

### 4️⃣ إضافة iOS App

#### الخطوة 1: إضافة التطبيق
1. في Dashboard، اضغط **Add app** (رمز iOS)
2. اكتب معرّف الحزمة:
   ```
   com.example.toDoAppWithBloc
   ```
3. اضغط **Register app**

#### الخطوة 2: تحميل GoogleService-Info.plist
1. ستجد زر **Download GoogleService-Info.plist**
2. احفظ الملف في:
   ```
   ios/Runner/
   ```
3. في Xcode:
   - اضغط **Copy items if needed**
   - اختر **Runner** target

#### الخطوة 3: نسخ البيانات
```
نفس البيانات من Android (API Key, App ID, إلخ)
```

---

### 5️⃣ تحديث firebase_options.dart

افتح الملف:
```
lib/firebase_options.dart
```

واستبدل البيانات:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY', // ← استبدل
  appId: '1:123456789:android:abc123def', // ← استبدل
  messagingSenderId: '123456789', // ← استبدل
  projectId: 'to-do-app', // ← استبدل
  storageBucket: 'to-do-app.appspot.com', // ← استبدل
);
```

---

## 🔗 أين تجد البيانات؟

### في Firebase Console:

1. **Project Settings**
   - اضغط على ⚙️ (الترس) في الأعلى
   - اختر **Project settings**

2. **General Tab**
   ```
   Project ID: ← هنا
   ```

3. **Service Accounts Tab**
   - اختر **Dart**
   - نسخ كل البيانات

---

## ✅ Checklist

- [ ] أنشأت Firebase Project
- [ ] أضفت Android App
- [ ] أضفت iOS App
- [ ] حملت google-services.json
- [ ] حملت GoogleService-Info.plist
- [ ] نسخت البيانات في firebase_options.dart
- [ ] تحققت من صحة البيانات

---

## 🚀 بعد إضافة البيانات:

```bash
flutter clean
flutter pub get
flutter run
```

---

## 📸 مثال من البيانات الفعلية:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyDfk3J4k5k6k7k8k9k0k1k2k3k4k5k6k7k',
  appId: '1:123456789012:android:abcdef123456def',
  messagingSenderId: '123456789012',
  projectId: 'to-do-app-b2f3e',
  storageBucket: 'to-do-app-b2f3e.appspot.com',
);
```

---

**ملاحظة**: لا تشارك هذه البيانات في GitHub أو أي مكان عام!
