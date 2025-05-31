import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class AccountScreen extends StatefulWidget {
  final String bankName;

  const AccountScreen({super.key, required this.bankName});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<List<dynamic>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = Provider.of<AuthProvider>(context, listen: false)
        .fetchAccounts(widget.bankName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cuentas: ${widget.bankName}')),
      body: FutureBuilder<List<dynamic>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las cuentas'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay cuentas disponibles'));
          }

          final accounts = snapshot.data!;
          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final acc = accounts[index];
              return ListTile(
                title: Text(acc['name']),
                subtitle: Text('Saldo: \$${acc['balance']}'),
                trailing: Text(acc['type']),
              );
            },
          );
        },
      ),
    );
  }
}