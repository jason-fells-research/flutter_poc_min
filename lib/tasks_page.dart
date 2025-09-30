import 'package:flutter/material.dart';
import 'api.dart';

class TasksPage extends StatefulWidget {
  final Api api;
  const TasksPage({super.key, required this.api});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Map<String, dynamic>> _tasks = [];
  bool _loading = true;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await widget.api.listTasks();
      setState(() {
        _tasks = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      // For demo, just show a SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks: $e')),
        );
      }
    }
  }

  void _toggle(int index, bool? value) async {
    // optimistic toggle (local only; API is read-only in this demo)
    setState(() => _tasks[index]['done'] = value == true);
    try {
      await widget.api.updateTaskFull(_tasks[index]); // no-op but keeps shape
    } catch (_) {}
  }

  void _add() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    // optimistic add (local only; give a temp id)
    final newTask = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title,
      'done': false,
    };
    setState(() {
      _tasks = [..._tasks, newTask];
      _controller.clear();
    });
    try {
      await widget.api.createTask(title); // no-op
    } catch (_) {}
  }

  void _delete(int index) async {
    final id = _tasks[index]['id'];
    final backup = _tasks[index];
    setState(() {
      _tasks = List.from(_tasks)..removeAt(index);
    });
    try {
      await widget.api.deleteTask(id); // no-op
    } catch (_) {
      // revert on failure
      setState(() {
        _tasks = List.from(_tasks)..insert(index, backup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'New task',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _add(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _add,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: _tasks.isEmpty
                      ? const Center(child: Text('No tasks yet'))
                      : ListView.separated(
                          itemCount: _tasks.length,
                          separatorBuilder: (_, __) => const Divider(height: 0),
                          itemBuilder: (context, i) {
                            final t = _tasks[i];
                            return Dismissible(
                              key: ValueKey(t['id']),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _delete(i),
                              background: Container(
                                color: Theme.of(context).colorScheme.errorContainer,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: const Icon(Icons.delete),
                              ),
                              child: CheckboxListTile(
                                value: (t['done'] ?? false) as bool,
                                onChanged: (v) => _toggle(i, v),
                                title: Text('${t['title']}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
