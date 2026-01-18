// =====================================
// User Model - نموذج بيانات المستخدم
// =====================================

/// كلاس User بيمثل بيانات المستخدم
/// بيحتوي على معلومات المستخدم الأساسية
class User {
  final String id; // معرف المستخدم الفريد
  final String firstName; // الاسم الأول
  final String lastName; // الاسم الأخير
  final String email; // البريد الإلكتروني للمستخدم
  final String
  password; // كلمة السر (ملاحظة: في التطبيقات الحقيقية نخزنها مشفرة)

  /// Constructor - البناء الأساسي للـ User
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  /// الحصول على الاسم الكامل
  String get fullName => '$firstName $lastName';

  /// Constructor بديل للتوافق مع الكود القديم
  factory User.fromOldFormat({
    required String id,
    required String name,
    required String email,
    required String password,
  }) {
    final nameParts = name.split(' ');
    return User(
      id: id,
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      email: email,
      password: password,
    );
  }

  /// Method بترجع نسخة من User بقيم جديدة
  /// مفيدة جداً لـ immutability
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// تحويل User إلى JSON (للتخزين)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }

  /// تحويل من JSON إلى User (القراءة من التخزين)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
