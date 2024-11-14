import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final Function(String) onLanguageChanged;
  final ApiService apiService;
  final String comunicadoNombre;
  final String comunicadoDescripcion;
  final Function(String, String) onTextTranslated;

  LanguageSelector({
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
    required this.apiService,
    required this.comunicadoNombre,
    required this.comunicadoDescripcion,
    required this.onTextTranslated,
  });

  Future<void> _translateTexts() async {
    try {
      String translatedNombre = await apiService.translateText(comunicadoNombre, "es", selectedLanguage);
      String translatedDescripcion = await apiService.translateText(comunicadoDescripcion, "es", selectedLanguage);
      onTextTranslated(translatedNombre, translatedDescripcion);
    } catch (e) {
      print("Error en la traducción: $e");
    }
  }

  String _getFlagPath(String languageCode) {
    switch (languageCode) {
      case 'es':
        return 'assets/lottie/espana.png';
      case 'en':
        return 'assets/lottie/estados-unidos.png';
      case 'fr':
        return 'assets/lottie/francia.png';
      case 'de':
        return 'assets/lottie/alemania.png';
      case 'it':
        return 'assets/lottie/italia.png';
      default:
        return 'assets/lottie/espana.png'; // Valor predeterminado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Seleccionar idioma:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedLanguage,
          dropdownColor: const Color.fromRGBO(33, 34, 56, 1),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              onLanguageChanged(newValue);
              await _translateTexts();
            }
          },
          items: languages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Image.asset(
                    _getFlagPath(value),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    value.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
