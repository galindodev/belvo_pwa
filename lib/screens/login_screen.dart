import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => email = value,
                    validator:
                        (value) => value!.isEmpty ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onChanged: (value) => password = value,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 24),
                 FilledButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      final result = await authProvider.login(email, password);

      if (!context.mounted) return;

      if (result['status'] == 200) {
        try {
          final instituciones = await authProvider.fetchInstitutions();
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: instituciones,
          );
        } catch (e) {
          _showSnackBar('Error al obtener instituciones: $e');
        }
      } else {
        _showSnackBar(result['mssg']);
      }
    }
  },
  child: const Text('Login'),
),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('No tienes cuenta? Regístrate'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text('Powered by Jhorman Galindo :D',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
}