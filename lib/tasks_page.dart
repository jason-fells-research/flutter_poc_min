import 'package:flutter/material.dart';
import 'api.dart';

class TasksPage extends StatefulWidget {
  final ApiClient api;
  const TasksPage({super.key, required this.api});
  @override State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Map<String,dynamic>> _tasks = [];
  bool _loading = true;
  final _newCtl = TextEditingController();

  int _asInt(dynamic v, int fallback) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) { final p = int.tryParse(v); if (p != null) return p; }
    return fallback;
  }
  bool _asBool(dynamic v) {
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true';
    if (v is num) return v != 0;
    return false;
  }
  String _asTitle(dynamic v) => v?.toString() ?? 'Senza titolo';

  Future<void> _load() async {
    setState(() { _loading = true; });
    try {
      final data = await widget.api.listTasks();
      setState(() { _tasks = data; });
    } catch (_) {
      // keep whatever we had
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _create() async {
    final title = _newCtl.text.trim();
    if (title.isEmpty) return;
    _newCtl.clear();
    try { await widget.api.createTask(title); } catch (_) {}
    await _load();
  }

  // OPTIMISTIC: flip in UI first, then try sync; ignore failure for demo
  Future<void> _toggle(Map<String,dynamic> t, bool done) async {
    final idx = _tasks.indexOf(t);
    if (idx < 0) return;

    // snapshot
    final original = Map<String,dynamic>.from(t);

    // optimistic update
    setState(() { _tasks[idx] = {...t, 'done': done}; });

    // attempt server sync with PATCH then PUT fallback (api.dart handles)
    try {
      final idPath = t['id']; // use raw id as returned
      final full = {
        'id': _asInt(idPath, idx),
        'title': _asTitle(t['title']),
        'done': done,
      };
      await widget.api.updateTaskFull(full);
      // on success, optionally re-load to reflect server truth
      // await _load();
    } catch (_) {
      // leave UI as-is for the demo; if you prefer, rollback:
      // setState(() { _tasks[idx] = original; });
    }
  }

  // Also optimistic: remove from UI first
  Future<void> _delete(int id, int idx) async {
    final removed = _tasks[idx];
    setState(() { _tasks.removeAt(idx); });
    try {
      await widget.api.deleteTask(id);
    } catch (_) {
      // rollback on failure
      setState(() { _tasks.insert(idx, removed); });
    }
  }

  @override void initState() { super.initState(); _load(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attività')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _newCtl,
              decoration: const InputDecoration(hintText: 'Nuova attività...'))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _create, child: const Text('Aggiungi')),
          ]),
        ),
        Expanded(
          child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _tasks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final t = _tasks[i];
                  final id = _asInt(t['id'], i);
                  final title = _asTitle(t['title']);
                  final done = _asBool(t['done']);
                  return ListTile(
                    title: Text(title, style: TextStyle(
                      decoration: done ? TextDecoration.lineThrough : null)),
                    leading: Checkbox(
                      value: done,
                      onChanged: (v) => _toggle(t, v ?? false),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(id, i),
                    ),
                  );
                }),
        ),
      ]),
    );
  }
}
