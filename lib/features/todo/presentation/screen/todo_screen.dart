import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/events.dart';
import '../bloc/task_state.dart';
import '../../domain/entities/task.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // العنوان اللي فوق في الاب بار
      appBar: AppBar(title: const Text("To Do App")),

      body: Column(
        children: [
          // Expanded علشان ياخد باقي مساحة الشاشة
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              // BlocBuilder بيراقب حالة التاسكات و يعمل rebuild لما الحالة تتغير
              builder: (context, state) {
                // لو مفيش أي تاسكات لسه
                if (state.tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      "No tasks yet!",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // لو فيه تاسكات → نعرضها في ListView
                return ListView.builder(
                  itemCount: state.tasks.length, // عدد التاسكات
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return ListTile(
                      // اسم التاسك
                      title: Text(
                        task.title,
                        style: TextStyle(
                          // لو متعلم عليها انها خلصت يبقى عليها خط
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      // checkbox علشان يحدد التاسك خلصت ولا لأ
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          // هنا بنبعت event لتغيير حالة التاسك
                          context.read<TaskBloc>().add(ToggleTask(task.id));
                        },
                      ),

                      // زراير تعديل وحذف على يمين كل تاسك
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زرار تعديل
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditTaskDialog(context, task);
                            },
                          ),
                          // زرار حذف
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<TaskBloc>().add(DeleteTask(task.id));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // زرار لإضافة تاسك جديدة
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  50,
                ), // الزرار يبقى عريض
              ),
              child: const Text("Add Task"),
              onPressed: () {
                _showAddTaskDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- [ Dialog إضافة تاسك جديدة ] -----------------
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    // دالة داخلية بتتعامل مع إضافة التاسك
    void addTask() {
      final title = controller.text.trim();
      if (title.isNotEmpty) {
        // نتحقق لو فيه تاسك بنفس الاسم ولسه مش منتهية
        final exists = context.read<TaskBloc>().state.tasks.any(
          (task) =>
              !task.isCompleted &&
              task.title.toLowerCase() == title.toLowerCase(),
        );
        if (exists) {
          // لو موجودة → نعرض رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Task already exists!"),
              backgroundColor: Colors.red,
            ),
          );
          return; // منضيفش
        } else {
          // لو مش موجودة → نضيفها
          final task = Task(id: DateTime.now().toString(), title: title);
          context.read<TaskBloc>().add(AddTask(task));
          Navigator.pop(context); // نقفل الـ dialog
        }
      }
    }

    // عرض الـ Dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter task name"),
          onSubmitted: (_) => addTask(), // دعم الضغط على Enter
        ),
        actions: [
          // زرار إلغاء
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // زرار إضافة
          ElevatedButton(onPressed: addTask, child: const Text("Add")),
        ],
      ),
    );
  }

  // ----------------- [ Dialog تعديل تاسك موجودة ] -----------------
  void _showEditTaskDialog(BuildContext context, Task task) {
    final TextEditingController controller = TextEditingController(
      text: task.title,
    ); // النص الحالي للتاسك يظهر جوه الـ TextField

    // دالة داخلية لحفظ التعديل
    void saveTask() {
      final newTitle = controller.text.trim();
      if (newTitle.isNotEmpty) {
        // التحقق: مينفعش تاسك جديدة غير منتهية يكون اسمها زي أي واحدة غير منتهية
        final exists = context.read<TaskBloc>().state.tasks.any(
          (t) =>
              t.id != task.id && // نتأكد إننا مش بنقارن بنفس التاسك
              !t.isCompleted &&
              t.title.toLowerCase() == newTitle.toLowerCase(),
        );
        if (exists) {
          // لو الاسم مستخدم → رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Task already exists!"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        } else {
          // لو الاسم تمام → نعمل تحديث
          final updatedTask = Task(
            id: task.id,
            title: newTitle,
            isCompleted: task.isCompleted,
          );
          context.read<TaskBloc>().add(UpdateTask(updatedTask));
          Navigator.pop(context); // نقفل الـ dialog بعد الحفظ
        }
      }
    }

    // عرض Dialog التعديل
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new task name"),
          onSubmitted: (_) => saveTask(), // دعم الضغط على Enter
        ),
        actions: [
          // زرار إلغاء
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // زرار حفظ
          ElevatedButton(onPressed: saveTask, child: const Text("Save")),
        ],
      ),
    );
  }
}
