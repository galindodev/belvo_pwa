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

  Future<bool> signup(String email, String password) async {
  final url = Uri.parse('$baseUrl/users/signup');
  final response = await http.post(
    url,
    body: json.encode({"email": email, "password": password}),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    _user = User.fromJson(data['user']); // opcional, si devuelves el user
    _token = data['token']; // si también te devuelven el token
    notifyListeners();
    return true;
  } else {
    return false;
  }
}

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
} 