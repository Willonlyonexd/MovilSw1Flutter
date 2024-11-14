import 'package:flutter/material.dart';
import '../models/comunicado_model.dart';
import '../services/api_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/media_list.dart';

class ComunicadoDetailScreen extends StatefulWidget {
  final Comunicado comunicado;

  ComunicadoDetailScreen({required this.comunicado});

  @override
  _ComunicadoDetailScreenState createState() => _ComunicadoDetailScreenState();
}

class _ComunicadoDetailScreenState extends State<ComunicadoDetailScreen> {
  final ApiService apiService = ApiService();
  String selectedLanguage = 'es';
  List<String> languages = ['es', 'en', 'fr', 'de', 'it'];

  String originalNombre = '';
  String originalDescripcion = '';

  @override
  void initState() {
    super.initState();
    // Guardar los valores originales para traducciones
    originalNombre = widget.comunicado.nombre;
    originalDescripcion = widget.comunicado.descripcion;
  }

  Future<void> _translateText(String targetLanguage) async {
    try {
      // Usar los valores originales para cada traducción
      String translatedNombre = await apiService.translateText(
          originalNombre, "es", targetLanguage);
      String translatedDescripcion = await apiService.translateText(
          originalDescripcion, "es", targetLanguage);

      setState(() {
        widget.comunicado.nombre = translatedNombre;
        widget.comunicado.descripcion = translatedDescripcion;
      });
    } catch (e) {
      print("Error en la traducción: $e");
    }
  }

  void _onTextTranslated(String translatedNombre, String translatedDescripcion) {
    setState(() {
      widget.comunicado.nombre = translatedNombre;
      widget.comunicado.descripcion = translatedDescripcion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
      appBar: AppBar(
        title: Text(widget.comunicado.nombre),
        backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LanguageSelector(
              selectedLanguage: selectedLanguage,
              languages: languages,
              onLanguageChanged: (newLang) async {
                setState(() {
                  selectedLanguage = newLang;
                });
                await _translateText(newLang);
              },
              apiService: apiService,
              comunicadoNombre: originalNombre,
              comunicadoDescripcion: originalDescripcion,
              onTextTranslated: _onTextTranslated,
            ),
            const SizedBox(height: 20),
            Text(
              widget.comunicado.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Descripción: ${widget.comunicado.descripcion}",
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              "Fecha: ${widget.comunicado.fecha}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Multimedia:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MediaList(
                multimedia: widget.comunicado.multimedia,
                selectedLanguage: selectedLanguage,
                apiService: apiService,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
