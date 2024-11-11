import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  static String baseUrl = 'http://localhost:8069';

  // Método para iniciar sesión en Odoo
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result']['success']) {
        final token = data['result']['data']['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return {'success': true, 'token': token};
      } else {
        return {'success': false, 'error': data['result']['message']};
      }
    } else {
      return {'success': false, 'error': 'Error en el servidor'};
    }
  }

  // Método para obtener el token almacenado
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Método para cerrar sesión
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
