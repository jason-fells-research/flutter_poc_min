import 'dart:convert';
import 'package:http/http.dart' as http;

/// If you pass a BASE_URL in --dart-define, we’ll use it.
/// Otherwise it defaults to empty so relative paths still work.
const _ENV_BASE = String.fromEnvironment('BASE_URL', defaultValue: '');

class Api {
  final String base;
  Api([String? baseUrl]) : base = baseUrl ?? _ENV_BASE;

  Uri _u(String path) => Uri.parse('$base$path');

  Future<List<Map<String, dynamic>>> listTasks() async {
    final resp = await http.get(_u('/tasks'));
    if (resp.statusCode != 200) {
      throw Exception('Failed: ${resp.statusCode}');
    }
    final raw = jsonDecode(resp.body) as List;
    return raw.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getTask(String id) async {
    final resp = await http.get(_u('/tasks/$id'));
    if (resp.statusCode != 200) {
      throw Exception('Failed: ${resp.statusCode}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  // --- No-op methods so the FE's optimistic UI compiles against read-only API ---
  Future<void> createTask(String title) async {
    // Intentionally a no-op: serverless API is read-only for the demo.
  }

  Future<void> updateTaskFull(Map<String, dynamic> full) async {
    // Intentionally a no-op.
  }

  Future<void> deleteTask(String id) async {
    // Intentionally a no-op.
  }
}

/// Back-compat shim so existing code that references `ApiClient` compiles.
class ApiClient extends Api {
  ApiClient([String? baseUrl]) : super(baseUrl);
}
