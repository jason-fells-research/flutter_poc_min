import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  String? _jwt;
  ApiClient(this.baseUrl);
  void setToken(String? t) { _jwt = t; }

  Map<String,String> _headers() => {
    'Content-Type': 'application/json',
    if (_jwt != null) 'Authorization': 'Bearer $_jwt',
  };

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final res = await http.post(url, headers: _headers(),
      body: jsonEncode({'username': username, 'password': password}));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'] as String?;
      _jwt = token;
      return token;
    }
    throw Exception('Login failed: ${res.statusCode} ${res.body}');
  }

  Future<List<Map<String,dynamic>>> listTasks() async {
    final url = Uri.parse('$baseUrl/tasks');
    final res = await http.get(url, headers: _headers());
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.cast<Map<String,dynamic>>();
    }
    throw Exception('List failed: ${res.statusCode} ${res.body}');
  }

  Future<Map<String,dynamic>> createTask(String title) async {
    final url = Uri.parse('$baseUrl/tasks');
    final res = await http.post(url, headers: _headers(),
      body: jsonEncode({'title': title, 'done': false}));
    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String,dynamic>;
    }
    throw Exception('Create failed: ${res.statusCode} ${res.body}');
  }

  // Update tolerant: try PATCH; if server says 404/405, retry PUT with full object
  Future<Map<String,dynamic>> updateTaskFull(Map<String,dynamic> task) async {
    final id = task['id'];
    final url = Uri.parse('$baseUrl/tasks/$id');

    // 1) Try PATCH (partial)
    var res = await http.patch(url, headers: _headers(),
      body: jsonEncode({'done': task['done']}));
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String,dynamic>;
    }

    // 2) Fallback to PUT with full object (json-server friendly)
    if (res.statusCode == 404 || res.statusCode == 405) {
      res = await http.put(url, headers: _headers(), body: jsonEncode(task));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String,dynamic>;
      }
    }

    throw Exception('Update failed: ${res.statusCode} ${res.body}');
  }

  Future<void> deleteTask(dynamic id) async {
    final url = Uri.parse('$baseUrl/tasks/$id');
    final res = await http.delete(url, headers: _headers());
    if (res.statusCode == 204 || res.statusCode == 200) return;
    throw Exception('Delete failed: ${res.statusCode} ${res.body}');
  }
}
