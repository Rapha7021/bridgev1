import 'package:flutter/material.dart';
import 'bridge_api_service.dart';
import 'transactions_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Créer un Utilisateur')),
        body: UserCreationScreen(),
      ),
    );
  }
}

class UserCreationScreen extends StatelessWidget {
  final BridgeApiService apiService = BridgeApiService();

  @override
  Widget build(BuildContext context) {
    _checkAuthentication(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              apiService.createUserAndAuthenticate(context);
            },
            child: Text('Créer un Utilisateur'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final transactions = await apiService.fetchTransactions();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionsScreen(transactions: transactions),
                ),
              );
            },
            child: Text('Voir les Transactions'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAuthentication(BuildContext context) async {
    String? token = await apiService.loadAccessToken();
    if (token != null) {
      apiService.accessToken = token;
      final transactions = await apiService.fetchTransactions();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionsScreen(transactions: transactions),
        ),
      );
    }
  }
}
