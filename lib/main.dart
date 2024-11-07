import 'package:flutter/material.dart';
import 'bridge_api_service.dart';

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
    return Center(
      child: ElevatedButton(
        onPressed: () {
          apiService.createUserAndAuthenticate(context);
        },
        child: Text('Créer un Utilisateur'),
      ),
    );
  }
}
