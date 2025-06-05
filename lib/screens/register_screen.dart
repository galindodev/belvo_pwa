import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Éxito'),
        content: const Text('Usuario registrado exitosamente'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

 Future<void> _submit(AuthProvider authProvider) async {
  if (_formKey.currentState!.validate()) {
    try {
      final result = await authProvider.signup(email, password);
      if (!context.mounted) return;

      if (result['status'] == 201) {
        _showSuccessDialog();
      } else {
        _showSnackBar(result['mssg']);
      }
    } catch (e) {
      _showSnackBar('Error al registrar: $e');
    }
  }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
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
                  _buildEmailField(),
                  const SizedBox(height: 12),
                  _buildPasswordField(),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _submit(authProvider),
                    child: const Text('Registrarse'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => email = value,
      validator: (value) => value!.isEmpty ? 'Ingresa tu correo' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      onChanged: (value) => password = value,
      validator: (value) => value!.isEmpty ? 'Ingresa tu contraseña' : null,
    );
  }
}