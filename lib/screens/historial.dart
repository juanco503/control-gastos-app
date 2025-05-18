import 'package:flutter/material.dart';
import '../models/transaction.dart';

class HistoryScreen extends StatefulWidget {
  final List<Transaction> transacciones; // Lista general de transacciones

  const HistoryScreen({
    Key? key,
    required this.transacciones,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String tipoFiltro = 'Todos'; // Filtro por tipo: Todos, Ingresos, Gastos
  String categoriaFiltro = 'Todas'; // Filtro por categoría
  DateTime? fechaInicio; // Fecha inicial del filtro
  DateTime? fechaFin; // Fecha final del filtro

  // Obtener lista única de categorías
  List<String> obtenerCategorias() {
    return ['Todas', ...{for (var t in widget.transacciones) t.category}];
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> filtradas = [...widget.transacciones];

    // Aplicar filtros
    if (tipoFiltro != 'Todos') {
      filtradas = filtradas.where(
        (t) => tipoFiltro == 'Ingresos' ? t.type == 'ingreso' : t.type == 'gasto',
      ).toList();
    }

    if (categoriaFiltro != 'Todas') {
      filtradas = filtradas.where((t) => t.category == categoriaFiltro).toList();
    }

    if (fechaInicio != null) {
      filtradas = filtradas.where(
        (t) => t.date.isAfter(fechaInicio!) || t.date.isAtSameMomentAs(fechaInicio!),
      ).toList();
    }

    if (fechaFin != null) {
      filtradas = filtradas.where(
        (t) => t.date.isBefore(fechaFin!) || t.date.isAtSameMomentAs(fechaFin!),
      ).toList();
    }

    // Ordenar por fecha descendente
    filtradas.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      body: Column(
        children: [
          // Filtros de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                // Filtro por tipo
                DropdownButton<String>(
                  value: tipoFiltro,
                  items: ['Todos', 'Gastos', 'Ingresos']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => tipoFiltro = value!),
                ),
                // Filtro por categoría
                DropdownButton<String>(
                  value: categoriaFiltro,
                  items: obtenerCategorias()
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => categoriaFiltro = value!),
                ),
                // Filtro por fecha de inicio
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fechaInicio ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => fechaInicio = date);
                    }
                  },
                  child: Text(
                    fechaInicio == null
                        ? 'Desde'
                        : 'Desde: ${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}',
                  ),
                ),
                // Filtro por fecha de fin
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fechaFin ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => fechaFin = date);
                    }
                  },
                  child: Text(
                    fechaFin == null
                        ? 'Hasta'
                        : 'Hasta: ${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}',
                  ),
                ),
              ],
            ),
          ),
          // Lista de transacciones
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filtradas.length,
              itemBuilder: (context, index) {
                final trans = filtradas[index];
                final esIngreso = trans.type == 'ingreso';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                      color: esIngreso ? Colors.green : Colors.red,
                    ),
                    title: Text(trans.title), // Título de la transacción
                    subtitle: Text(
                      '${trans.category} • ${trans.date.day}/${trans.date.month}/${trans.date.year}',
                    ),
                    trailing: Text(
                      '\$${trans.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: esIngreso ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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