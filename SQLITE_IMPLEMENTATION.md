# تطبيق SQLite - شرح شامل

## 📱 نظرة عامة

تم تطبيق قاعدة بيانات SQLite محلية لتخزين بيانات المستخدمين (التسجيل والدخول) بدلاً من Firebase.

## 🗂️ الملفات المضافة / المعدلة

### 1. **pubspec.yaml** ✅
```yaml
dependencies:
  sqflite: ^2.3.0      # مكتبة SQLite للـ Flutter
  path: ^1.8.3         # للتعامل مع مسارات الملفات
```

### 2. **lib/features/auth/data/sources/database_helper.dart** ✅
**الهدف:** إدارة دورة حياة قاعدة البيانات

**المميزات:**
- Singleton Pattern - ضمان instance واحد من DB
- `_initDatabase()` - تحديد مسار قاعدة البيانات
- `_createDatabase()` - إنشاء جدول `users`
- `close()` - إغلاق الاتصال
- `deleteDatabase()` - حذف قاعدة البيانات كاملة

**جدول Users:**
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  firstName TEXT NOT NULL,
  lastName TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
```

### 3. **lib/features/auth/data/sources/user_data_source.dart** ✅
**الهدف:** عمليات CRUD على جدول المستخدمين

**الدوال المتاحة:**

| الدالة | الوصف |
|--------|-------|
| `createUser(User)` | إضافة مستخدم جديد + التحقق من تكرار البريد |
| `getUserByEmail(String)` | البحث عن مستخدم برقم البريد (تسجيل دخول) |
| `getUserById(String)` | البحث عن مستخدم برقم معرف |
| `getAllUsers()` | الحصول على جميع المستخدمين |
| `updateUser(User)` | تحديث بيانات مستخدم |
| `deleteUser(String)` | حذف مستخدم واحد |
| `deleteAllUsers()` | حذف جميع المستخدمين |
| `getUserCount()` | عد عدد المستخدمين |

### 4. **lib/features/auth/data/models/user_model.dart** ✅
**المتغيرات:**
- `id` - معرف فريد (timestamp)
- `firstName` - الاسم الأول
- `lastName` - الاسم الأخير
- `email` - البريد الإلكتروني (فريد)
- `password` - كلمة المرور
- `createdAt` - تاريخ التسجيل

**الدوال:**
- `toJson()` - تحويل للـ JSON (للتخزين)
- `fromJson()` - قراءة من JSON

### 5. **lib/features/auth/data/repositories/auth_repository_impl.dart** ✅
**الهدف:** التواسل بين BLoC و SQLite

**الدوال:**
```dart
Future<User> login(String email, String password)
Future<User> register(String email, String password, String name)
Future<List<User>> getAllUsers()
Future<int> getUserCount()
Future<bool> isLoggedIn()
Future<void> logout()
User? getCurrentUser()
```

**الميزات:**
- استخدام `SharedPreferences` لتخزين المستخدم الحالي
- معالجة الأخطاء الشاملة
- طباعة debug info

## 📊 التدفق البيانات

```
RegisterScreen
    ↓
RegisterBloc
    ↓
AuthRepositoryImpl
    ↓
UserDataSource
    ↓
DatabaseHelper
    ↓
SQLite Database
```

## 🔐 عملية التسجيل الجديد (Register)

1. المستخدم يدخل: بريد، كلمة مرور، الاسم
2. `RegisterScreen` ترسل event للـ `RegisterBloc`
3. `AuthRepository.register()` تُنشئ User object
4. `UserDataSource.createUser()` تحفظ في SQLite
5. `SharedPreferences` تحفظ المستخدم الحالي
6. عرض Dialog نجاح مع البيانات
7. الانتقال إلى `LoginScreen`

## 🔓 عملية تسجيل الدخول (Login)

1. المستخدم يدخل: بريد، كلمة مرور
2. `LoginScreen` ترسل event للـ `LoginBloc`
3. `AuthRepository.login()` تبحث عن المستخدم
4. `UserDataSource.getUserByEmail()` تقرأ من SQLite
5. التحقق من كلمة المرور
6. `SharedPreferences` تحفظ المستخدم الحالي
7. الانتقال إلى `HomeScreen` أو `TaskScreen`

## 📝 ملاحظات مهمة

### ⚠️ أمان كلمات المرور
**الوضع الحالي:** كلمات المرور تُحفظ كـ plain text (غير آمن)

**الحل الموصى به للإنتاج:**
```dart
import 'package:crypto/crypto.dart';

// تشفير كلمة المرور
String hashedPassword = sha256.convert(utf8.encode(password)).toString();
```

### ✅ ميزات SQLite المستخدمة

| الميزة | التفصيل |
|--------|----------|
| UNIQUE | البريد الإلكتروني فريد (منع التكرار) |
| NOT NULL | جميع الحقول مطلوبة |
| PRIMARY KEY | معرف فريد لكل مستخدم |
| ConflictAlgorithm.replace | استبدال عند التكرار |

### 📦 بيانات المستخدم في SharedPreferences
```json
{
  "current_user": "{\"id\":\"1234567890\",\"firstName\":\"محمد\",\"lastName\":\"أحمد\",\"email\":\"user@example.com\",\"createdAt\":\"2024-01-15T10:30:00.000\"}"
}
```

## 🧪 اختبار SQLite

### في Console:
```dart
// اختبار التسجيل
var repo = AuthRepositoryImpl();
var user = await repo.register(
  'test@example.com',
  'password123',
  'محمد أحمد'
);
print(user.toJson());

// اختبار تسجيل الدخول
var loggedUser = await repo.login('test@example.com', 'password123');
print(loggedUser.email);

// عد المستخدمين
int count = await repo.getUserCount();
print('عدد المستخدمين: $count');
```

## 🔄 مسار البيانات

```
SharedPreferences (Session)
         ↑
         │
  AuthRepositoryImpl
         ↑
         │
  UserDataSource (CRUD)
         ↑
         │
  DatabaseHelper (Connection)
         ↑
         │
  SQLite Database (Storage)
```

## ✨ الميزات المستقبلية الممكنة

- [ ] تشفير كلمات المرور
- [ ] نسخ احتياطي قاعدة البيانات
- [ ] مزامنة مع Cloud (اختياري)
- [ ] البحث المتقدم
- [ ] تصفية المستخدمين
- [ ] الفرز حسب التاريخ

## 📚 الموارد المستخدمة

- [sqflite Documentation](https://pub.dev/packages/sqflite)
- [Flutter SQLite Tutorial](https://flutter.dev/docs/cookbook)
- [Dart JSON Serialization](https://dart.dev/guides/json)

---

**تم إنجاز التطبيق بنجاح! ✅**
