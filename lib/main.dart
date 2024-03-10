import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Homepage.dart';


void main()
async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyB3YexyXPrMUzRsR6bIRdd5yw-To46r350",
        appId: '1:553530326797:android:24eee762165e4b2b1c3a44',
        messagingSenderId: '553530326797',
        projectId: 'todo-list-e9c24')
  //
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      ChangeNotifierProvider(
        create: (context) => TaskModel(),
        child: App(),
      ),
    );
  }
}

