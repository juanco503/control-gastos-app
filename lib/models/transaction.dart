// models/transaction.dart

class Transaction {
  final String description; // Descripción del gasto/ingreso
  final double amount;      // Monto
  final String category;    // Categoría
  final DateTime date;      // Fecha
  final bool isIncome;      // True si es ingreso, false si es gasto

  Transaction({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });
}