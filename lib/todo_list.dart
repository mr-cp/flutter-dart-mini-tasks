
// 🎨 Task ::: 1
// Todo with shared preference::::::::



import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _prefs = SharedPreference();
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _todos = await _prefs.getTodo();
    setState(() {});
  }

  // addTodo::::::
  Future _addTodo(String title, String subTitle) async {
    final todo = Todo(id: const Uuid().v4(), title: title, subTitle: subTitle);
    _todos.add(todo);
    await _prefs.setTodo(_todos);
    titleController.clear();
    subTitleController.clear();
    setState(() {});
  }

  // deleteTodo::::::
  Future _deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _prefs.setTodo(_todos);
    setState(() {});
  }

// updateTodo:::::::
  Future _updateTodo(Todo updatedTodo) async {
    final index = _todos.indexWhere((t) => t.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      await _prefs.setTodo(_todos);
      setState(() {});
    }
  }

  void _showEditDialog({Todo? todo}) {
    if (todo != null) {
      titleController.text = todo.title;
      subTitleController.text = todo.subTitle;
    }
    else{
      titleController.clear();
      subTitleController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                todo == null ? 'Add Note' : 'Edit Note',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    label: Text('Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: subTitleController,
                decoration: InputDecoration(
                    label: Text('Subtitle'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black))),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      final subTitle = subTitleController.text.trim();
                      if (titleController.text.trim().isNotEmpty) {
                        if (todo == null) {
                          _addTodo(title, subTitle);
                        } else {
                          final updatedTodo = Todo(
                            id: todo.id,
                            title: title,
                            subTitle: subTitle,
                            isDone: todo.isDone,
                          );
                          _updateTodo(updatedTodo);
                        }

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Ok'),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.teal[100],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _todos[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _todos[index].subTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    _showEditDialog(todo: _todos[index]);
                  },
                  icon: Icon(Icons.edit),
                ),
                SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    _deleteTodo(_todos[index].id);
                  },
                  icon: Icon(Icons.delete),
                ),
                SizedBox(width: 15),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        backgroundColor: Colors.teal,
        onPressed: () {
          _showEditDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

///// model class::::

class Todo {
  String id;
  String title;
  String subTitle;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.subTitle,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        title: json['title'],
        subTitle: json['subTitle'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subTitle': subTitle,
        'isDone': isDone,
      };
  @override
  String toString() {
    return 'Todo(id: $id, title: $title, subTitle: $subTitle, isDone: $isDone)';
  }
}

///// sharedpreference:::
class SharedPreference {
  static const stringKey = 'stringValue';

  Future<List<Todo>> getTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(stringKey) ?? [];
    return data.map((e) => Todo.fromJson(json.decode(e))).toList();
  }

  Future<void> setTodo(List<Todo> todo) async {
    final prefs = await SharedPreferences.getInstance();
    final data = todo.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(stringKey, data);
  }
}
