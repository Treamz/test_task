import 'dart:isolate';
import 'dart:math';

class Task {
  final int id;
  late Isolate isolate;
  late ReceivePort receivePort;
  late SendPort sendPort;

  Task(this.id);

  Future<void> startTask(Function(int, String) updateStatus) async {
    receivePort = ReceivePort();
    receivePort.listen((message) {
      if (message is SendPort) {
        sendPort = message;
      } else if (message is String) {
        updateStatus(id, message);
        if (message.contains("done")) {
          isolate.kill(priority: Isolate.immediate);
        }
      }
    });
    isolate = await Isolate.spawn(taskEntryPoint, receivePort.sendPort);
  }

}

void taskEntryPoint(SendPort sendPort) async {
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);


  var random = Random();
  var duration = Duration(seconds: random.nextInt(5) + 1);
  var startTime = DateTime.now();
  await Future.delayed(duration); // Simulate some work
  sendPort.send("Task is running");

  var endTime = DateTime.now();
  var executionTime = endTime.difference(startTime).inSeconds;
  sendPort.send("Task done in $executionTime seconds");
}
