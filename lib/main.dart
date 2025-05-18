//Importaciones de login y CRUD
import 'login/login_page.dart';
import 'login/register_page.dart';
import 'login/update_page.dart';
import 'login/delete_page.dart';

//Importaciones app
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'screens/dashboard.dart';
import 'screens/add_expenses.dart';
import 'screens/add_income.dart';


void main() {
  runApp(MyApp());
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
        '/': (context) => LoginPage(), //Pantalla inicial
        '/home': (context) => FinanzasHome(), //Pantalla de app de finanzas
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
  final List<Transaction> _gastos = [];
  final List<Transaction> _ingresos = [];
  int _selectedIndex = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App de Finanzas'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(gastos: _gastos, ingresos: _ingresos),
          AddExpenseScreen(onAdd: _addGasto),
          AddIncomeScreen(onAdd: _addIngreso),
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
        ],
      ),
    );
  }
}