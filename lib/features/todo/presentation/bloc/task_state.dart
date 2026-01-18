import 'package:equatable/equatable.dart';
import 'package:to_do_app_with_bloc/features/todo/domain/entities/task.dart';

class TaskState extends Equatable {
  final List<Task> tasks; // قائمة المهام
  final String? errorMessage; // رسالة خطأ لو حصل تضارب اسماء
  final Task? taskToEdit; // المهمة اللي محتاجة تعديل لو فيه تضارب أسماء

  const TaskState({this.tasks = const [], this.errorMessage, this.taskToEdit});

  // copyWith علشان نقدر نعمل نسخة جديدة مع تعديل حاجة معينة
  TaskState copyWith({
    List<Task>? tasks,
    String? errorMessage,
    Task? taskToEdit,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
      taskToEdit: taskToEdit ?? this.taskToEdit,
    );
  }

  @override
  List<Object?> get props => [tasks, errorMessage, taskToEdit];
}
