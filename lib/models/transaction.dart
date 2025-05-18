
class Transaction {
  final String id;  //id de transaccion
  final String title; //descripcion de transaccion
  final double amount; // monton de transaccion
  final DateTime date; // fecha de transaccion
  final String type; // "ingreso" o "gasto"
  final String category; //categoria 

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  /// Convertir a JSON para guardar
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type,
        'category': category,
      };

  /// Crear objeto desde JSON recuperado
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date']),
        type: json['type'],
        category: json['category'],
      );
}