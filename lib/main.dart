import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'screens/dashboard.dart';
import 'screens/add_expenses.dart';
import 'screens/add_income.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Listas para almacenar gastos e ingresos ingresados
  final List<Transaction> _gastos = [];
  final List<Transaction> _ingresos = [];
  int _selectedIndex = 0; // Índice seleccionado en la barra de navegación

  // Callbacks para agregar una nueva transacción a las listas correspondientes
  void _addGasto(Transaction gasto) {
    setState(() {
      _gastos.add(gasto);
    });
  }
  void _addIngreso(Transaction ingreso) {
    setState(() {
      _ingresos.add(ingreso);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Finanzas',
      theme: ThemeData(
        useMaterial3: true,                  // Activa Material 3:contentReference[oaicite:4]{index=4}
        colorSchemeSeed: Colors.blue,       // Color principal semilla (Material 3)
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mi App de Finanzas'),
        ),
        // Cuerpo según pestaña seleccionada
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            //Se borraron los children de las demas screens
            DashboardScreen(gastos: _gastos, ingresos: _ingresos),
            AddExpenseScreen(onAdd: _addGasto),
            AddIncomeScreen(onAdd: _addIngreso),
     
          ],
        ),
        // Barra de navegación inferior (Material 3)
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          // Destinos con icono y etiqueta
          destinations: const <NavigationDestination>[
            NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
            NavigationDestination(icon: Icon(Icons.add_circle), label: 'Gasto'),
            NavigationDestination(icon: Icon(Icons.attach_money), label: 'Ingreso'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
            NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Estadísticas'),
          ],
        ),
      ),
    );
  }
}