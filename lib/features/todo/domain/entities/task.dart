class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isUpdated; //  جديد: علشان نميز المهمة المعدلة

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isUpdated = false, // القيمة الافتراضية false
  });

  // copyWith بيخلينا نعدل أي قيمة ونرجع نسخة جديدة من الـ Task
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isUpdated, //  جديد
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isUpdated: isUpdated ?? this.isUpdated, // جديد
    );
  }
}
