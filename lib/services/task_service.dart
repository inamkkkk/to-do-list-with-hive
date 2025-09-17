import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_hive/models/task.dart';

class TaskService extends ChangeNotifier {
  final _tasksBox = Hive.box<Task>('tasks');

  List<Task> get tasks => _tasksBox.values.toList();

  TaskService() {
    loadTasks();
  }

  Future<void> addTask(Task task) async {
    await _tasksBox.add(task);
    task.key = _tasksBox.keyAt(_tasksBox.length - 1);
    notifyListeners();
  }

  Future<void> updateTask(Task task, String newTitle) async {
    task.title = newTitle;
    await _tasksBox.put(task.key, task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await _tasksBox.delete(task.key);
    notifyListeners();
  }

  Future<void> toggleCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _tasksBox.put(task.key, task);
    notifyListeners();
  }

  Future<void> loadTasks() async {
    for (int i = 0; i < _tasksBox.length; i++) {
      _tasksBox.getAt(i)?.key = _tasksBox.keyAt(i);
    }
    notifyListeners();
  }
}