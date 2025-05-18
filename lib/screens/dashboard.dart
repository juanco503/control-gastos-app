// screens/dashboard.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  final List<Transaction> transacciones;

  const DashboardScreen({
    Key? key,
    required this.transacciones,
  }) : super(key: key);

  /// Calcula el total de gastos por categoría (solo transacciones tipo 'gasto')
  Map<String, double> calcularGastosPorCategoria() {
    final Map<String, double> mapa = {};
    for (var t in transacciones.where((t) => t.type == 'gasto')) {
      mapa[t.category] = (mapa[t.category] ?? 0) + t.amount;
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar y calcular totales por tipo
    final totalGastos = transacciones
        .where((t) => t.type == 'gasto')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalIngresos = transacciones
        .where((t) => t.type == 'ingreso')
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = totalIngresos - totalGastos;
    final categorias = calcularGastosPorCategoria();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen general',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Ingresos: \$${totalIngresos.toStringAsFixed(2)}'),
          Text('Gastos: \$${totalGastos.toStringAsFixed(2)}'),
          Text('Balance: \$${balance.toStringAsFixed(2)}'),
          const SizedBox(height: 24),
          const Text(
            'Distribución de gastos por categoría',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PieChartGastos(data: categorias),
          ),
        ],
      ),
    );
  }
}

/// PieChart personalizado para mostrar distribución de gastos
class PieChartGastos extends StatelessWidget {
  final Map<String, double> data;

  const PieChartGastos({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos de gastos disponibles'));
    }

    final total = data.values.fold(0.0, (a, b) => a + b);
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];

    return PieChart(
      PieChartData(
        sections: data.entries.mapIndexed((index, e) {
          final porcentaje = (e.value / total) * 100;
          return PieChartSectionData(
            value: e.value,
            color: colors[index % colors.length],
            title: '${porcentaje.toStringAsFixed(1)}%',
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}

/// Extensión para mapear con índice (equivalente a mapIndexed en Kotlin)
extension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E item) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}