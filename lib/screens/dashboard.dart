// screens/dashboard.dart

import 'package:flutter/material.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  final List<Transaction> gastos;
  final List<Transaction> ingresos;

  const DashboardScreen({
    super.key,
    required this.gastos,
    required this.ingresos,
  });

  @override
  Widget build(BuildContext context) {
    // Calcula totales
    double totalGastos = 0;
    for (var g in gastos) {
      totalGastos += g.amount;
    }
    double totalIngresos = 0;
    for (var i in ingresos) {
      totalIngresos += i.amount;
    }
    double balance = totalIngresos - totalGastos;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen General',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text('Ingresos totales: \$${totalIngresos.toStringAsFixed(2)}'),
          Text('Gastos totales: \$${totalGastos.toStringAsFixed(2)}'),
          Text('Balance: \$${balance.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}