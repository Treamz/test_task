import 'package:flutter/material.dart';
import 'package:flutter_test_task/task.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  Map<int, String> taskStatus = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      addTask(i);
    }
  }

  void addTask(int id) {
    Task task = Task(id);
    setState(() {
      tasks.add(task);
      taskStatus[id] = "Task $id is running";
    });
    task.startTask((taskId, status) {
      setState(() {
        taskStatus[taskId] = status;
        if (tasks.every((task) => taskStatus[task.id]?.contains("done") ?? false)) {
          taskStatus[-1] = "All tasks complete";
        }
      });
    });
  }

  void addNewTask() {
    int id = tasks.length;
    addTask(id);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(taskStatus[tasks[index].id] ?? 'Unknown status'),
                  );
                },
              ),
            ),
            if (taskStatus.containsKey(-1))
              Text(
                taskStatus[-1]!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addNewTask,
              child: const Text('Add New Task'),
            ),
          ],
        ),
      ),
    );
  }
}
