import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';
import 'tasks_page.dart';

class LoginPage extends StatefulWidget {
  final ApiClient api;
  const LoginPage({super.key, required this.api});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _busy = false;
  String? _error;

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      final token = await widget.api.login(_userCtl.text, _passCtl.text);
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => TasksPage(api: widget.api)));
      } else {
        setState(() { _error = 'Credenziali non valide'; });
      }
    } catch (e) { setState(() { _error = e.toString(); }); }
    finally { setState(() { _busy = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _userCtl,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (v) => (v==null || v.isEmpty) ? 'Obbligatorio' : null),
            TextFormField(
              controller: _passCtl, obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (v) => (v==null || v.isEmpty) ? 'Obbligatorio' : null),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _doLogin,
                child: _busy ? const CircularProgressIndicator() : const Text('Entra'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
