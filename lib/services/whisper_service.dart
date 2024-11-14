/* whisper_service.dart 
import 'dart:convert';
import 'package:http/http.dart' as http;

class WhisperService {
  final String apiKey = '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'; // Reemplaza con tu clave de API real

  Future<String> transcribeAudio(String audioUrl) async {
    final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'url': audioUrl,  // Enviar el URL del archivo de audio o video
        'model': 'whisper-1',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['text'];
    } else {
      print("Error en la transcripción: ${response.body}");
      throw Exception('Error en la transcripción');
    }
  }
}
*/