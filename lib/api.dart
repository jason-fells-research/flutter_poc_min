import 'dart:convert';
import 'package:http/http.dart' as http;

// Empty by default => relative to current origin (works on Vercel)
const _BASE = String.fromEnvironment('BASE_URL', defaultValue: '');
Uri _u(String path) => Uri.parse('$_BASE$path');

class Api {
  static Future<List<Map<String, dynamic>>> listTasks() async {
    final resp = await http.get(_u('/tasks'));
    if (resp.statusCode != 200) { throw Exception('Failed: ${resp.statusCode}'); }
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> getTask(String id) async {
    final resp = await http.get(_u('/tasks/$id'));
    if (resp.statusCode != 200) { throw Exception('Failed: ${resp.statusCode}'); }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }
}
