import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';


class ApiService {
  static Future<List<dynamic>> getInstitutions(String token) async {
    final url = Uri.parse('$baseUrl/belvos/institutions');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Error al obtener instituciones');
    }
  }
}