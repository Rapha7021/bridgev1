import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionsScreen({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            title: Text(transaction.description), // Affiche la description
            subtitle: Text(DateFormat('yyyy-MM-dd').format(transaction.date)), // Affiche la date
            trailing: Text('${transaction.amount} €'), // Affiche le montant
          );
        },
      ),
    );
  }
}
