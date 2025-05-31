import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  final List<dynamic> institutions;

  const HomeScreen({super.key, required this.institutions});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: institutions.length,
        itemBuilder: (context, index) {
          final inst = institutions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 6.0,
            ),
            child: Card(
              elevation: 2,
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/accounts',
                    arguments: inst['name'],
                  );
                },
                leading: SvgPicture.network(
                  inst['icon_logo'],
                  width: 40,
                  placeholderBuilder:
                      (_) => const CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text(inst['display_name']),
                subtitle: Text(inst['name']),
              ),
            ),
          );
        },
      ),
    );
  }
}
