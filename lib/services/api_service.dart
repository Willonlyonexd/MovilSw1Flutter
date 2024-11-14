import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';
import '../models/comunicado_model.dart';
import '../utils/token_manager.dart';

class ApiService {
  final String azureEndpoint = 'https://sw1.cognitiveservices.azure.com/';
  final String azureSubscriptionKey =
      'AZNp6rR3o5qxz7hINtXoFLagqPjEHXt7AR31Do7f1P7noRwRPVTwJQQJ99AKACYeBjFXJ3w3AAAFACOGBDfz';

  Future<User?> login(String username, String password) async {
    final url = Uri.parse(ApiConfig.baseUrl + ApiConfig.loginEndpoint);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['result'] != null &&
          responseData['result']['success'] == true) {
        return User.fromJson(responseData['result']);
      } else {
        throw Exception(
            responseData['result']?['message'] ?? 'Error de autenticación');
      }
    } else {
      throw Exception('Error de autenticación');
    }
  }

  Future<List<Comunicado>> getComunicados() async {
    String? token = await TokenManager.getToken();
    if (token == null) throw Exception("Token de autenticación no disponible");

    final url = Uri.parse(ApiConfig.baseUrl + ApiConfig.comunicadosEndpoint);

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Comunicado.fromJson(data)).toList();
    } else {
      throw Exception('Error al obtener los comunicados');
    }
  }

  Future<void> marcarComunicadoComoVisto(int comunicadoUsuarioId) async {
    String? token = await TokenManager.getToken();
    if (token == null) throw Exception("Token de autenticación no disponible");

    final url = Uri.parse(
        ApiConfig.baseUrl + '/api/comunicados/visto/$comunicadoUsuarioId');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al marcar el comunicado como visto');
    }
  }

  Future<String> translateText(
      String text, String sourceLang, String targetLang) async {
    const int maxQueryLength = 500;
    List<String> fragments = [];

    for (int i = 0; i < text.length; i += maxQueryLength) {
      int end =
          (i + maxQueryLength < text.length) ? i + maxQueryLength : text.length;
      fragments.add(text.substring(i, end));
    }

    String translatedText = '';

    for (String fragment in fragments) {
      final url = Uri.parse(
          'https://api.mymemory.translated.net/get?q=$fragment&langpair=$sourceLang|$targetLang');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        translatedText += responseData['responseData']['translatedText'] + ' ';
      } else {
        throw Exception('Error en la traducción con MyMemory');
      }
    }

    return translatedText.trim();
  }

  Future<String> extractTextFromImage(String imageUrl) async {
    final url = Uri.parse('$azureEndpoint/vision/v3.2/read/analyze');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Ocp-Apim-Subscription-Key': azureSubscriptionKey,
      },
      body: jsonEncode({'url': imageUrl}),
    );

    if (response.statusCode == 202) {
      final operationLocation = response.headers['operation-location'];
      if (operationLocation == null)
        throw Exception('Operation location not found');

      await Future.delayed(Duration(seconds: 2));

      final resultResponse = await http.get(
        Uri.parse(operationLocation),
        headers: {
          'Ocp-Apim-Subscription-Key': azureSubscriptionKey,
        },
      );

      if (resultResponse.statusCode == 200) {
        final data = jsonDecode(resultResponse.body);
        final readResults = data['analyzeResult']['readResults'];
        String extractedText = '';

        for (var page in readResults) {
          for (var line in page['lines']) {
            extractedText += '${line['text']}\n';
          }
        }

        return extractedText;
      } else {
        throw Exception('Error retrieving text extraction result');
      }
    } else {
      throw Exception('Error starting text extraction');
    }
  }
}
