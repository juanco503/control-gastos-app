// Importaciones de login y CRUD
import 'login/login_page.dart';
import 'login/register_page.dart';
import 'login/update_page.dart';
import 'login/delete_page.dart';

// Importaciones app
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'screens/dashboard.dart';
import 'screens/add_expenses.dart';
import 'screens/add_income.dart';
import 'screens/historial.dart';
import 'screens/estadisticas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Finanzas con Login',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginPage(),        // Pantalla inicial
        '/home': (context) => const FinanzasHome(), // Pantalla de app de finanzas
        '/register': (context) => RegisterPage(),
        '/update': (context) => UpdatePage(),
        '/delete': (context) => DeletePage(),
      },
    );
  }
}

/// Pantalla principal después del login exitoso
class FinanzasHome extends StatefulWidget {
  const FinanzasHome({super.key});

  @override
  State<FinanzasHome> createState() => _FinanzasHomeState();
}

class _FinanzasHomeState extends State<FinanzasHome> {
  final List<Transaction> _transacciones = [];
  int _selectedIndex = 0;

  // Agrega una transacción de tipo gasto
  void _addGasto(Transaction gasto) {
    setState(() {
      _transacciones.add(gasto);
    });
  }

  // Agrega una transacción de tipo ingreso
  void _addIngreso(Transaction ingreso) {
    setState(() {
      _transacciones.add(ingreso);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App de Finanzas'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(transacciones: _transacciones),       // Pantalla de resumen
          AddExpenseScreen(onAdd: _addGasto),                    // Agregar gasto
          AddIncomeScreen(onAdd: _addIngreso),                   // Agregar ingreso
          HistoryScreen(transacciones: _transacciones),          // Historial de transacciones
          StatisticsScreen(transacciones: _transacciones),       // Estadísticas por categoría
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'Gasto'),
          NavigationDestination(icon: Icon(Icons.attach_money), label: 'Ingreso'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'Estadísticas'),
        ],
      ),
    );
  }
}
