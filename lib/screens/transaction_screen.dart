import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class TransactionScreen extends StatefulWidget {
  final String accountId;
  final String linkId;

  const TransactionScreen({
    super.key,
    required this.accountId,
    required this.linkId,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late Future<Map<String, dynamic>> _transactionFuture;

  @override
  void initState() {
    super.initState();
    _transactionFuture = Provider.of<AuthProvider>(context, listen: false)
        .fetchTransactions(widget.accountId, widget.linkId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transacciones')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar transacciones'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay transacciones disponibles'));
          }

          final data = snapshot.data!;
          final ingresos = data['ingresos'];
          final egresos = data['egresos'];
          final kpi = data['kpi_balance'];
          final transacciones = data['transacciones'] as List<dynamic>;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('💰 KPI Balance: \$${kpi.toStringAsFixed(2)}'),
                    Text('⬆️ Ingresos: \$${ingresos.toStringAsFixed(2)}'),
                    Text('⬇️ Egresos: \$${egresos.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: transacciones.length,
                  itemBuilder: (context, index) {
                    final tx = transacciones[index];
                    return ListTile(
                      leading: tx['logo'] != null
                          ? Image.network(
                              tx['logo'],
                              width: 40,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.transcribe_sharp),
                            )
                          : const Icon(Icons.account_balance_wallet),
                      title: Text(tx['comercio'] ?? 'Sin comercio'),
                      subtitle: Text(
                        '${tx['descripcion'] ?? ''} - ${tx['fecha'] ?? ''}',
                      ),
                      trailing: Text(
                        '\$${tx['monto']}',
                        style: TextStyle(
                          color: tx['tipo'] == 'INFLOW'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}