import '../../domain/entities/task.dart';

abstract class TaskEvent {}

// إضافة مهمة جديدة
class AddTask extends TaskEvent {
  final Task task;
  AddTask(this.task);
}

// تبديل حالة المهمة (مكتملة / غير مكتملة)
class ToggleTask extends TaskEvent {
  final String taskId;
  ToggleTask(this.taskId);
}

// حذف مهمة
class DeleteTask extends TaskEvent {
  final String taskId;
  DeleteTask(this.taskId);
}

// تعديل مهمة موجودة
class UpdateTask extends TaskEvent {
  final Task updatedTask;
  UpdateTask(this.updatedTask);
}

// فتح نافذة التعديل (Dialog) لو حصل تكرار اسم بعد إلغاء انهاء مهمة
class OpenEditTaskDialog extends TaskEvent {
  final Task task;
  OpenEditTaskDialog(this.task);
}
