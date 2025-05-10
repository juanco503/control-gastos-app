// screens/add_expense_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
//import 'dart:math';

class AddExpenseScreen extends StatefulWidget {
  final Function(Transaction) onAdd;
  const AddExpenseScreen({super.key, required this.onAdd});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // Lista de categorías de ejemplo
  static const List<String> _categories = [
    'Alimentos', 'Transporte', 'Salud', 'Entretenimiento', 'Otros'
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Abre el selector de fecha de Flutter
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked!;
      });
    }
  }

  // Valida y envía el formulario
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final gasto = Transaction(
        description: _descController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: _selectedDate,
        isIncome: false,
      );
      widget.onAdd(gasto); // Llama al callback en main.dart

      // Limpiar el formulario
      _formKey.currentState!.reset();
      _descController.clear();
      _amountController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
      });

      // Mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gasto agregado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Clave para validar el formulario
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar Gasto', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            // Campo de texto para descripción
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una descripción';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            // Campo de texto para monto (número)
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese un monto';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingrese un número válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            // Selector de categoría
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoría'),
              value: _selectedCategory,
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione una categoría';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            // Selector de fecha
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón para enviar
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Agregar Gasto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}