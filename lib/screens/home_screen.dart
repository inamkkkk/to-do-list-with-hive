import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_hive/models/task.dart';
import 'package:todo_hive/services/task_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Consumer<TaskService>(
        builder: (context, taskService, child) {
          return ListView.builder(
            itemCount: taskService.tasks.length,
            itemBuilder: (context, index) {
              final task = taskService.tasks[index];
              return Dismissible(
                key: Key(task.key.toString()),
                onDismissed: (direction) {
                  taskService.deleteTask(task);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task deleted'),
                    ),
                  );
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  title: Text(task.title),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      taskService.toggleCompletion(task);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, task);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    final titleController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final title = titleController.text;
                if (title.isNotEmpty) {
                  taskService.addTask(Task(title: title));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, Task task) async {
    final taskService = Provider.of<TaskService>(context, listen: false);
    final titleController = TextEditingController(text: task.title);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter task title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final title = titleController.text;
                if (title.isNotEmpty) {
                  taskService.updateTask(task, title);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}