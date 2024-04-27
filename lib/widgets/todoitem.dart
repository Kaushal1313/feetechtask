import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoItem extends StatelessWidget {
  final Map<String, dynamic> todo;
  final Function(int) onDelete;
  final Function(int, String) onUpdate;

  const TodoItem({
    required this.todo,
    required this.onDelete,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(
          todo['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    _textFieldController.text = todo['title'];
                    return AlertDialog(
                      title: Text('Update Todo'),
                      content: TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          hintText: "Enter new todo",
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CANCEL'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text('UPDATE'),
                          onPressed: () {
                            onUpdate(todo['id'], _textFieldController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onDelete(todo['id']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
