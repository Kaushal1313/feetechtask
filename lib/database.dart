import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/appcolors.dart';
import 'package:flutter_application_2/widgets/todolist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
      },
      version: 1,
    );

    final todos = await _getTodos();
    if (todos.isNotEmpty) {
      setState(() {}); 
    }
  }

  Future<void> _insertTodo(String title) async {
    await _database.insert(
      'todos',
      {'title': title},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _getTodos() async {
    return await _database.query('todos');
  }

  Future<void> _deleteTodo(int id) async {
    await _database.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  Future<void> _updateTodo(int id, String newTitle) async {
    await _database.update(
      'todos',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter SQFlite Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.blue,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: _getTodos(),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final todos = snapshot.data!;
              return TodoList(
                todos: todos,
                onDelete: _deleteTodo,
                onUpdate: _updateTodo,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintText: "Enter todo",
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
                    child: Text('ADD'),
                    onPressed: () {
                      _insertTodo(_textFieldController.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: CustomColors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
}
