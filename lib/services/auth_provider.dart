import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';
import '../config/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/auth');
    final response = await http.post(
      url,
      body: json.encode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = User.fromJson(data['user']);
      _token = data['token'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<List<dynamic>> fetchInstitutions() async {
    final url = Uri.parse('$baseUrl/belvos/institutions');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al obtener instituciones');
    }
  }

 Future<Map<String, dynamic>> signup(String email, String password) async {
  final url = Uri.parse('$baseUrl//users/signup');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  final data = jsonDecode(response.body);

  return {
    'status': response.statusCode,
    'mssg': data['mssg'] ?? 'Ocurrió un error desconocido'
  };
}

  Future<List<dynamic>> fetchAccounts(String bankName) async {
    final url = Uri.parse('$baseUrl/belvos/accounts');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
      body: json.encode({"bank_name": bankName}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('No se pudieron obtener las cuentas');
    }
  }

  Future<Map<String, dynamic>> fetchTransactions(String accountId) async {
    final url = Uri.parse('$baseUrl/belvos/transactions');
    final response = await http.post(
      url,
      body: json.encode({"account_id": accountId}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener transacciones');
    }
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
