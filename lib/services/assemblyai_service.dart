import 'dart:convert';
import 'package:http/http.dart' as http;

class AssemblyAIService {
  final String apiKey = 'd2905139e5244f119a65df9d80ffd198'; // Reemplaza con tu clave API de AssemblyAI

  // Método para iniciar la transcripción
  Future<String> startTranscription(String audioUrl, {String languageCode = 'en'}) async {
    final url = Uri.parse('https://api.assemblyai.com/v2/transcript');
    final response = await http.post(
      url,
      headers: {
        'authorization': apiKey,
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'audio_url': audioUrl,
        'language_code': languageCode,
        'punctuate': true
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['id']; // Devuelve el ID de la transcripción para obtener el resultado más adelante
    } else {
      throw Exception("Error al iniciar la transcripción: ${response.body}");
    }
  }

  // Método para obtener el resultado de la transcripción
  Future<String> getTranscriptionResult(String transcriptionId) async {
    final url = Uri.parse('https://api.assemblyai.com/v2/transcript/$transcriptionId');
    final response = await http.get(
      url,
      headers: {
        'authorization': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'completed') {
        return responseData['text']; // Retorna el texto transcrito si está completo
      } else if (responseData['status'] == 'processing') {
        throw Exception('La transcripción aún no está completa');
      } else {
        throw Exception("Error en la transcripción: ${responseData['status']}");
      }
    } else {
      throw Exception("Error al obtener la transcripción: ${response.body}");
    }
  }
}
