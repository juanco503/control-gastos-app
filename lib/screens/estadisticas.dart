// screens/statistics_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Transaction> transacciones;

  const StatisticsScreen({
    super.key,
    required this.transacciones,
  });

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime? fechaInicio;
  DateTime? fechaFin;

  /// Filtra las transacciones por tipo 'gasto' y las agrupa por categoría
  Map<String, double> calcularGastosPorCategoria() {
    final gastosFiltrados = widget.transacciones.where((t) {
      return t.type == 'gasto' &&
          (fechaInicio == null || !t.date.isBefore(fechaInicio!)) &&
          (fechaFin == null || !t.date.isAfter(fechaFin!));
    });

    final Map<String, double> mapa = {};
    for (var g in gastosFiltrados) {
      mapa[g.category] = (mapa[g.category] ?? 0) + g.amount;
    }
    return mapa;
  }

  /// Agrupa transacciones por mes y suma los montos
  Map<String, double> calcularPorMes(String tipo) {
    final Map<String, double> mensual = {};
    for (var t in widget.transacciones.where((t) => t.type == tipo)) {
      final mes = DateFormat('yyyy-MM').format(t.date);
      mensual[mes] = (mensual[mes] ?? 0) + t.amount;
    }
    return mensual;
  }

@override
Widget build(BuildContext context) {
  final categorias = calcularGastosPorCategoria();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Estadísticas'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tendencia mensual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 250,
            child: _MonthlyTrendChart(
              gastos: widget.transacciones.where((t) => t.type == 'gasto').toList(),
              ingresos: widget.transacciones.where((t) => t.type == 'ingreso').toList(),
            ),
          ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fechaInicio ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => fechaInicio = date);
                  },
                  child: Text(fechaInicio == null
                      ? 'Desde'
                      : 'Desde: ${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}'),
                ),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fechaFin ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) setState(() => fechaFin = date);
                  },
                  child: Text(fechaFin == null
                      ? 'Hasta'
                      : 'Hasta: ${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Gastos por categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: categorias.entries
                      .map((e) => BarChartGroupData(
                            x: categorias.keys.toList().indexOf(e.key),
                            barRods: [
                              BarChartRodData(toY: e.value, color: Colors.indigo)
                            ],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < categorias.keys.length) {
                            return Text(
                              categorias.keys.elementAt(idx),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Gráfico de líneas con la tendencia mensual de ingresos y gastos
class _MonthlyTrendChart extends StatelessWidget {
  final List<Transaction> gastos;
  final List<Transaction> ingresos;

  const _MonthlyTrendChart({
    required this.gastos,
    required this.ingresos,
  });

  Map<String, double> calcularPorMes(List<Transaction> transacciones) {
    final Map<String, double> mensual = {};
    for (var t in transacciones) {
      final mes = DateFormat('yyyy-MM').format(t.date);
      mensual[mes] = (mensual[mes] ?? 0) + t.amount;
    }
    return mensual;
  }

  @override
  Widget build(BuildContext context) {
    final gastosMensuales = calcularPorMes(gastos);
    final ingresosMensuales = calcularPorMes(ingresos);
    final meses = {
      ...gastosMensuales.keys,
      ...ingresosMensuales.keys,
    }.toList()
      ..sort();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: meses.asMap().entries.map((e) {
              final mes = e.value;
              return FlSpot(e.key.toDouble(), gastosMensuales[mes] ?? 0);
            }).toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: meses.asMap().entries.map((e) {
              final mes = e.value;
              return FlSpot(e.key.toDouble(), ingresosMensuales[mes] ?? 0);
            }).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < meses.length) {
                  final label = meses[index].substring(5); // MM
                  return Text(label, style: const TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
