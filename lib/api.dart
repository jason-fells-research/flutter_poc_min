import 'dart:convert';
import 'package:http/http.dart' as http;

// Empty by default => relative to current origin (works on Vercel)
const _BASE = String.fromEnvironment('BASE_URL', defaultValue: '');
Uri _u(String path) => Uri.parse('$_BASE$path');

class Api {
  const Api();

  // ----- static helpers (used by tests/other code if needed)
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

  // ----- instance API (what lib/tasks_page.dart calls)
  Future<List<Map<String, dynamic>>> listTasks() => listTasksStatic();

  // Demo is read-only on the server. Keep the UI shape by no-op stubs:
  Future<void> createTask(String title) async {
    // no-op on server; simulate latency so UI feels normal
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  Future<void> updateTaskFull(Map<String, dynamic> full) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  Future<void> deleteTask(dynamic id) async {
    // accepts int or string; server is read-only
    await Future<void>.delayed(const Duration(milliseconds: 150));
  }

  Future<Map<String, dynamic>> getTask(String id) => getTaskStatic(id);
}
