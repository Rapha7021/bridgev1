class Transaction {
  final String description;  // Remplace title par description
  final DateTime date;
  final double amount;

  Transaction({
    required this.description,
    required this.date,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      description: json['clean_description'] ?? '',  // Met à jour la clé JSON
      date: DateTime.parse(json['date']),
      amount: json['amount']?.toDouble() ?? 0.0,
    );
  }
}
