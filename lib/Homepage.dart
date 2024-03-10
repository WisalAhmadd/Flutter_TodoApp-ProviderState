import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskModel extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  void addTask(String title) {
    FirebaseFirestore.instance.collection("Tasks").add({"Title": title});
  }

  void removeTask(String taskId) {
    FirebaseFirestore.instance.collection("Tasks").doc(taskId).delete();
  }

  Stream<List<Map<String, dynamic>>> getTasksStream() {
    return FirebaseFirestore.instance.collection("Tasks").snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) => {"taskId": doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      },
    );
  }
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: MaterialApp(
        color: Colors.blueGrey,
        home: Scaffold(
          backgroundColor: Colors.lightBlue,
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            title: Text(
              "TODO LIST",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: 3),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        controller: textController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusColor: Colors.white,
                          hintText: " Enter task",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Provider.of<TaskModel>(context, listen: false).addTask(textController.text);
                        textController.text = "";
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(colors: [Colors.cyan, Colors.blueAccent]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        width: 90,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Add Task",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Consumer<TaskModel>(
                  builder: (context, taskModel, child) {
                    return StreamBuilder<List<Map<String, dynamic>>>(
                      stream: taskModel.getTasksStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final tasks = snapshot.data!;
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Dismissible(
                              key: Key(task['taskId']),
                              onDismissed: (direction) {
                                Provider.of<TaskModel>(context, listen: false).removeTask(task['taskId']);
                              },
                              background: Container(color: Colors.red),
                              child: ListTile(
                                title: Text(
                                  task['Title'] ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontSize: 20),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
