// azure_speech_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AzureSpeechService {
  final String azureEndpoint = 'https://eastus.api.cognitive.microsoft.com/';
  final String azureSubscriptionKey =
      '17TYJwrNEsCXdOuB95ZG2X44du7joeWjGaWLvlPiwTNyj80P34JyJQQJ99AKACYeBjFXJ3w3AAAYACOGFqLQ';

  Future<String> transcribeAudio(String audioUrl) async {
    final url = Uri.parse('${azureEndpoint}speechtotext/v3.0/transcriptions');

    final response = await http.post(
      url,
      headers: {
        'Ocp-Apim-Subscription-Key': azureSubscriptionKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contentUrls': [audioUrl],  // URL del archivo de audio
        'locale': 'en-US',          // Cambia al idioma necesario
        'displayName': 'TranscriptionTask',
        'properties': {
          'diarizationEnabled': false,
          'wordLevelTimestampsEnabled': false
        }
      }),
    );

    if (response.statusCode == 202) {
      final operationLocation = response.headers['operation-location'];
      if (operationLocation == null) throw Exception('Operation location not found');

      // Esperar unos segundos para que la transcripción esté lista
      await Future.delayed(Duration(seconds: 5));

      final resultResponse = await http.get(
        Uri.parse(operationLocation),
        headers: {
          'Ocp-Apim-Subscription-Key': azureSubscriptionKey,
        },
      );

      if (resultResponse.statusCode == 200) {
        final data = jsonDecode(resultResponse.body);
        final recognizedPhrases = data['combinedRecognizedPhrases'];
        
        if (recognizedPhrases != null && recognizedPhrases.isNotEmpty) {
          return recognizedPhrases.map((phrase) => phrase['display']).join('\n');
        } else {
          throw Exception('No se encontró texto transcrito.');
        }
      } else {
        throw Exception('Error al recuperar la transcripción.');
      }
    } else {
      print("Error en la solicitud de transcripción: ${response.body}");
      throw Exception('Error en la solicitud de transcripción');
    }
  }
}
