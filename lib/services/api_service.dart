import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comunicado.dart';

class ApiService {
  final String apiUrl = 'http://localhost:8069/api/comunicados/general';

  Future<List<Comunicado>> fetchComunicados() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comunicado) => Comunicado.fromJson(comunicado)).toList();
    } else {
      throw Exception('Error al cargar los comunicados');
    }
  }
}
