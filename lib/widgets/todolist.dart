import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/todoitem.dart';

class TodoList extends StatelessWidget {
  final List<Map<String, dynamic>> todos;
  final Function(int) onDelete;
  final Function(int, String) onUpdate;

  const TodoList({
    required this.todos,
    required this.onDelete,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onDelete: onDelete,
          onUpdate: onUpdate,
        );
      },
    );
  }
}
