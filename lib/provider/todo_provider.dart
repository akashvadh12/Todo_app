import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/model_class/todo_item.dart';


class TodoProvider with ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<TodoItem> _todoItems = [];
  bool _isLoading = true;

  List<TodoItem> get todoItems => _todoItems;
  bool get isLoading => _isLoading;

  TodoProvider() {
    _loadTodos();
  }

  void _loadTodos() {
    _database.child('todos').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        _todoItems = data.entries.map((entry) {
          return TodoItem.fromJson(entry.key, entry.value);
        }).toList();
      } else {
        _todoItems = [];
      }
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addTodo(TodoItem todo) async {
    await _database.child('todos').push().set(todo.toJson());
  }

  Future<void> updateTodo(TodoItem todo) async {
    await _database.child('todos/${todo.id}').update(todo.toJson());
  }

  Future<void> toggleTodoCompletion(TodoItem todo) async {
    await _database.child('todos/${todo.id}').update({
      'completed': !todo.completed,
    });
  }

  Future<void> deleteTodo(String id) async {
    await _database.child('todos/$id').remove();
  }
}
