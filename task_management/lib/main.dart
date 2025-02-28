import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(),
    );
  }
}

// Enum for task priority levels
enum TaskPriority { Low, Medium, High }

// Task model to store name, completion status, and priority
class Task {
  String name;
  bool isCompleted;
  TaskPriority priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

// Main screen for the Task Manager App
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> tasks = [];
  TaskPriority _selectedPriority = TaskPriority.Low; // Default priority

  // ✅ Add Task Function with Priority
  void _addTask() {
    setState(() {
      String taskName = _taskController.text.trim();
      if (taskName.isNotEmpty) {
        tasks.add(Task(name: taskName, priority: _selectedPriority));
        _taskController.clear();
        _selectedPriority = TaskPriority.Low; // Reset dropdown
        _sortTasks(); // Sort tasks after adding
      }
    });
  }

  // ✅ Toggle Task Completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // ✅ Delete Task Function
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // ✅ Sort Tasks by Priority (High → Medium → Low)
  void _sortTasks() {
    setState(() {
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    });
  }

  // Function to get color based on priority
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.High:
        return Colors.red;
      case TaskPriority.Medium:
        return Colors.orange;
      case TaskPriority.Low:
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager with Priority')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Task Input Field, Priority Selector, and Add Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<TaskPriority>(
                  value: _selectedPriority,
                  onChanged: (TaskPriority? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: TaskPriority.values.map((TaskPriority priority) {
                    return DropdownMenuItem<TaskPriority>(
                      value: priority,
                      child: Text(priority.name),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Task List Display
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text('No tasks yet!'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tasks[index].isCompleted,
                              onChanged: (_) => _toggleTaskCompletion(index),
                            ),
                            title: Text(
                              tasks[index].name,
                              style: TextStyle(
                                decoration: tasks[index].isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(
                              tasks[index].priority.name,
                              style: TextStyle(
                                color: _getPriorityColor(tasks[index].priority),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
