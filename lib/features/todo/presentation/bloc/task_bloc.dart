import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import 'task_state.dart';
import 'events.dart';

// TaskBloc هو المسؤول عن إدارة حالة المهام (tasks)
// بيتابع الأحداث (events) اللي بتحصل من الـ UI
// وبيصدر (emit) حالات جديدة (states) بناءً على الأحداث دي
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // البداية: الحالة الأولية بتكون لستة فاضية من المهام
  TaskBloc() : super(TaskState(tasks: [])) {
    // --------------------- [ AddTask ] ---------------------
    // إضافة مهمة جديدة
    on<AddTask>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)..add(event.task);
      emit(TaskState(tasks: updatedTasks));
    });

    // --------------------- [ ToggleTask ] ---------------------
    // تغيير حالة المهمة (مكتملة / غير مكتملة)
    on<ToggleTask>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isCompleted: !task.isCompleted);
        }
        return task;
      }).toList();
      emit(TaskState(tasks: updatedTasks));
    });

    // --------------------- [ DeleteTask ] ---------------------
    // حذف مهمة من القائمة
    on<DeleteTask>((event, emit) {
      final updatedTasks = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(TaskState(tasks: updatedTasks));
    });

    // --------------------- [ UpdateTask ] ---------------------
    // تعديل مهمة موجودة
    on<UpdateTask>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        if (task.id == event.updatedTask.id) {
          // نخلي المهمة المعدلة تاخد isUpdated = true
          return event.updatedTask.copyWith(isUpdated: true);
        }
        return task;
      }).toList();
      emit(TaskState(tasks: updatedTasks));
    });

    // --------------------- [ OpenEditTaskDialog ] ---------------------
    // فتح نافذة التعديل (Dialog) في حالة وجود تضارب أسماء
    // مفيش تعديل في اللستة هنا، مجرد إرسال الحالة زي ما هي
    // والـ UI هو اللي هيتعامل مع الفتح
    on<OpenEditTaskDialog>((event, emit) {
      emit(
        TaskState(
          tasks: state.tasks,
          taskToEdit: event.task, // نحط المهمة اللي محتاجه تعديل
        ),
      );
    });
  }
}
