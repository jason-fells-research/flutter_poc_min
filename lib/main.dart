import 'package:flutter/material.dart';
import 'api.dart';
import 'tasks_page.dart';

const String kBaseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8080');

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient(kBaseUrl);
    return MaterialApp(
      title: 'Minimal Flutter POC',
      theme: ThemeData(useMaterial3: true),
      home: TasksPage(api: api),
    );
  }
}
