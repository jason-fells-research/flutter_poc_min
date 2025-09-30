import 'package:flutter/material.dart';
import 'api.dart';
import 'tasks_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // If BASE_URL is provided at runtime, Api() will use it.
    final api = Api();
    return MaterialApp(
      title: 'Tasks Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: TasksPage(api: api),
    );
  }
}
