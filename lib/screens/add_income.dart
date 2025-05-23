// screens/add_income_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
import '../storage/transaction_storage';// Importa el storage
import 'package:uuid/uuid.dart'; // Para generar un id único

class AddIncomeScreen extends StatefulWidget {
  final Function(Transaction) onAdd;
  const AddIncomeScreen({super.key, required this.onAdd});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // Categorías
  static const List<String> _categories = ['Salario', 'Ventas', 'Otros'];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Selector de fecha
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Valida y envía el formulario
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final ingreso = Transaction(
        id: const Uuid().v4(), // Generar id único
        title: _descController.text, // descripción como título
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        type: 'ingreso', // tipo como string
        category: _selectedCategory!,
      );

      await TransactionStorage.addTransaction(ingreso); // Guarda localmente
      widget.onAdd(ingreso); // Notifica al widget padre

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
        const SnackBar(content: Text('Ingreso agregado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agregar Ingreso', style: Theme.of(context).textTheme.headlineSmall),
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
                child: const Text('Agregar Ingreso'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}