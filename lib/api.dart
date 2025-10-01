import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// On web: keep relative '' (same-origin).
// On non-web (macOS/iOS/Android): default to the production domain.
const String _DEFAULT_BASE_NON_WEB = 'https://flutterpocmin.vercel.app';

final String _BASE = const String.fromEnvironment(
  'BASE_URL',
  defaultValue: kIsWeb ? '' : _DEFAULT_BASE_NON_WEB,
);

Uri _u(String path) => Uri.parse('$_BASE$path');

class Api {
  const Api();

  static Future<List<Map<String, dynamic>>> listTasksStatic() async {
    final resp = await http.get(_u('/tasks'));
    if (resp.statusCode != 200) {
      throw Exception('Failed: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> getTaskStatic(String id) async {
    final resp = await http.get(_u('/tasks/$id'));
    if (resp.statusCode != 200) {
      throw Exception('Failed: ${resp.statusCode}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> listTasks() => listTasksStatic();

  // Read-only demo; keep shape for UI actions
  Future<void> createTask(String title) async =>
      Future<void>.delayed(const Duration(milliseconds: 150));

  Future<void> updateTaskFull(Map<String, dynamic> full) async =>
      Future<void>.delayed(const Duration(milliseconds: 150));

  Future<void> deleteTask(dynamic id) async =>
      Future<void>.delayed(const Duration(milliseconds: 150));

  Future<Map<String, dynamic>> getTask(String id) => getTaskStatic(id);
}
