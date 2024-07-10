
import 'package:flutter/material.dart';

import '../../../../core/data/models/todo_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoModel> todos;
  final Function(int index) onEdit;

  const TodoList({super.key, required this.todos, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          final icon = todo.priority == TodoModelPriority.high 
            ? const Icon(Icons.arrow_circle_up_outlined, color: Colors.redAccent) 
            : todo.priority == TodoModelPriority.medium
             ? const Icon(Icons.arrow_circle_right_outlined, color: Colors.orangeAccent) 
             : const Icon(Icons.arrow_circle_down_outlined);
          return Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 15, right: 5),
              title: Row(
                children: [
                  icon,
                  const SizedBox(width: 10),
                  Text(todo.title ?? ''),
                ],
              ),
              subtitle: Text(todo.description ?? ''),
              trailing: IconButton(
                onPressed: () {
                  onEdit.call(index);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}