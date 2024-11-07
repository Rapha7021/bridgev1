import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'transaction.dart';
import 'transactions_screen.dart';
import 'webview_screen.dart';

class BridgeApiService {
  final String baseUrl = 'https://api.bridgeapi.io/v2';
  final String clientId = '96a80b4117df44058bef05a04c082a59';
  final String clientSecret = 'slWpx68xqQBZhS5lqLVQrxTnMxRT5uZzUSC9fIPYDPusIgYrbwCN7wE1q06HM77Q';
  String? accessToken;

  Future<void> createUserAndAuthenticate(BuildContext context) async {
    final userCreationResponse = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Bridge-Version': '2021-06-01',
        'Content-Type': 'application/json',
        'Client-Id': clientId,
        'Client-Secret': clientSecret,
      },
    );

    if (userCreationResponse.statusCode == 201) {
      final uuid = jsonDecode(userCreationResponse.body)['uuid'];
      print('Utilisateur créé avec succès. UUID: $uuid');

      final authResponse = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {
          'Bridge-Version': '2021-06-01',
          'Content-Type': 'application/json',
          'Client-Id': clientId,
          'Client-Secret': clientSecret,
        },
        body: jsonEncode({'user_uuid': uuid}),
      );

      if (authResponse.statusCode == 200) {
        accessToken = jsonDecode(authResponse.body)['access_token'];
        print('Authentification réussie. Token d\'accès: $accessToken');
        await firstSynchronization(context);
      } else {
        print('Erreur d’authentification : ${authResponse.body}');
      }
    } else {
      print('Erreur lors de la création de l’utilisateur : ${userCreationResponse.body}');
    }
  }

  Future<void> firstSynchronization(BuildContext context) async {
    if (accessToken == null) {
      print('Aucun token d\'accès disponible. Veuillez vous authentifier d\'abord.');
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/connect/items/add'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Bridge-Version': '2021-06-01',
        'Client-Id': clientId,
        'Client-Secret': clientSecret,
      },
      body: jsonEncode({
        "country": "fr",
        "prefill_email": "email@gmail.com",
      }),
    );

    if (response.statusCode == 200) {
      final redirectUrl = jsonDecode(response.body)['redirect_url'];
      print('Synchronisation initiale réussie : $redirectUrl');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: redirectUrl)),
      ).then((_) async {
        await fetchTransactions(context);
      });
    } else {
      print('Erreur lors de la synchronisation initiale : ${response.body}');
    }
  }

  Future<List<Transaction>> fetchTransactions(BuildContext context) async {
    if (accessToken == null) {
      throw Exception('Aucun token d\'accès disponible.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/transactions/updated'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Bridge-Version': '2021-06-01',
        'Client-Id': clientId,
        'Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Accès à la clé 'resources' pour obtenir les transactions
      if (jsonResponse['resources'] is List) {
        List<dynamic> transactionsJson = jsonResponse['resources'];
        List<Transaction> transactions = transactionsJson.map((transaction) => Transaction.fromJson(transaction)).toList();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransactionsScreen(transactions: transactions)),
        );

        return transactions;
      } else {
        throw Exception('Aucune transaction trouvée ou mauvais format de données.');
      }
    } else {
      throw Exception('Erreur lors de la récupération des transactions : ${response.body}');
    }
  }

}
