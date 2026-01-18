# ⚡ الأوامر السريعة - للحفظ بسرعة

## 📌 أهم 5 أوامر

### 1️⃣ تحميل الـ packages
```bash
flutter pub get
```
**الفائدة:** تحميل جميع المكتبات  
**الاستخدام:** بعد كل تغيير في `pubspec.yaml`

---

### 2️⃣ تنظيف المشروع
```bash
flutter clean
```
**الفائدة:** حذف الملفات المؤقتة  
**الاستخدام:** عند أي مشكلة غريبة

---

### 3️⃣ تشغيل التطبيق
```bash
flutter run
```
**الفائدة:** بناء وتشغيل التطبيق  
**الاستخدام:** أثناء التطوير

---

### 4️⃣ فحص الأخطاء
```bash
flutter analyze
```
**الفائدة:** البحث عن الأخطاء والتحذيرات  
**الاستخدام:** قبل البناء النهائي

---

### 5️⃣ فحص الإعداد
```bash
flutter doctor
```
**الفائدة:** فحص شامل لـ Flutter و Android و iOS  
**الاستخدام:** عند وجود مشاكل

---

## 🚀 أوامر الإعداد الأول (تشغيل واحد فقط)

```bash
# 1. تثبيت FlutterFire
dart pub global activate flutterfire_cli

# 2. تثبيت Firebase
npm install -g firebase-tools

# 3. تحميل الـ dependencies
flutter pub get
```

---

## 🛠️ أوامر التطوير اليومية

### قبل البدء:
```bash
flutter pub get
flutter analyze
```

### أثناء العمل:
```bash
flutter run          # تشغيل عادي
flutter run -v       # تشغيل مع التفاصيل
```

### عند المشاكل:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📦 أوامر البناء النهائي

### Android:
```bash
flutter build apk --release
```

### iOS:
```bash
flutter build ios --release
```

### Web:
```bash
flutter build web
```

---

## 🎯 الكل في أمر واحد

### إعداد كامل:
```bash
flutter clean && flutter pub get && flutter analyze && flutter run
```

### بـ verbose mode:
```bash
flutter clean && flutter pub get && flutter run -v
```

---

## 📋 جدول سريع

| الحالة | الأمر |
|--------|------|
| 🆕 إعداد جديد | `dart pub global activate flutterfire_cli` |
| 📥 تحميل packages | `flutter pub get` |
| 🧹 تنظيف | `flutter clean` |
| ▶️ تشغيل | `flutter run` |
| 🔍 فحص أخطاء | `flutter analyze` |
| 🏥 فحص الإعداد | `flutter doctor` |
| 📦 بناء | `flutter build apk` |
| 🆘 مشاكل | `flutter clean && flutter pub get` |

---

**احفظ هذا الملف!** 📌
