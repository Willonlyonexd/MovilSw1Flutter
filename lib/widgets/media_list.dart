import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/comunicado_model.dart';
import '../services/api_service.dart';
import '../services/assemblyai_service.dart';

class MediaList extends StatefulWidget {
  final List<MultimediaItem> multimedia;
  final String selectedLanguage;
  final ApiService apiService;

  MediaList({
    required this.multimedia,
    required this.selectedLanguage,
    required this.apiService,
  });

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  VideoPlayerController? _videoController;
  bool isVideoInitialized = false;
  final AssemblyAIService assemblyAIService = AssemblyAIService();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause(String url) async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _downloadAndInitializeVideo(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_video.mp4';

      Dio dio = Dio();
      await dio.download(url, tempPath);

      _videoController = VideoPlayerController.file(File(tempPath))
        ..initialize().then((_) {
          setState(() {
            isVideoInitialized = true;
          });
        });
    } catch (e) {
      print("Error al descargar o inicializar el video: $e");
    }
  }

  Future<void> _transcribeAndTranslateMedia(String mediaUrl) async {
    try {
      // Inicia la transcripción en AssemblyAI
      String transcriptionId = await assemblyAIService.startTranscription(mediaUrl, languageCode: 'es');
      String transcribedText;

      // Polling para verificar si la transcripción está completa
      while (true) {
        await Future.delayed(Duration(seconds: 5));
        try {
          transcribedText = await assemblyAIService.getTranscriptionResult(transcriptionId);
          break; // Sale del loop cuando la transcripción esté completa
        } catch (e) {
          if (e.toString().contains('La transcripción aún no está completa')) {
            continue; // Continúa esperando si la transcripción aún no está lista
          } else {
            throw e;
          }
        }
      }

      // Traducir el texto transcrito al idioma seleccionado
      String translatedText = await widget.apiService.translateText(
        transcribedText,
        "es", // Idioma de origen de la transcripción
        widget.selectedLanguage, // Idioma seleccionado por el usuario
      );

      // Muestra la transcripción traducida en un diálogo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Transcripción"),
          content: Text(translatedText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cerrar"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error en la transcripción o traducción: $e");
    }
  }

  Future<void> _extractAndTranslateText(String imageUrl) async {
    try {
      String extractedText = await widget.apiService.extractTextFromImage(imageUrl);
      String translatedText = await widget.apiService.translateText(
          extractedText, "es", widget.selectedLanguage);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Texto traducido"),
          content: Text(translatedText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cerrar"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error al extraer o traducir el texto de la imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.multimedia.length,
      itemBuilder: (context, index) {
        final media = widget.multimedia[index];

        if (media.type == 'image/png' || media.type == 'image/jpeg') {
          return Column(
            children: [
              SizedBox(height: 10),
              Text(media.name, style: TextStyle(fontSize: 16)),
              Image.network(
                media.url,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Text('Error al cargar la imagen');
                },
              ),
              TextButton(
                onPressed: () => _extractAndTranslateText(media.url),
                child: Text("Extraer y traducir texto", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        } else if (media.type == 'audio/mpeg' || media.type == 'audio/mp3') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(media.name, style: TextStyle(fontSize: 16)),
              Text("Audio"),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () => _togglePlayPause(media.url),
              ),
              TextButton(
                onPressed: () => _transcribeAndTranslateMedia(media.url),
                child: Text("Transcribir y traducir audio",style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        } else if (media.type == 'video/mp4') {
          _downloadAndInitializeVideo(media.url);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(media.name, style: TextStyle(fontSize: 16)),
              Text("Video"),
              if (isVideoInitialized && _videoController != null)
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _videoController != null &&
                              _videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      _videoController!.pause();
                      _videoController!.seekTo(Duration.zero);
                      setState(() {});
                    },
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _transcribeAndTranslateMedia(media.url),
                child: Text("Transcribir y traducir video",style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(media.name, style: TextStyle(fontSize: 16)),
              Text("Tipo: ${media.type}"),
              Text("URL: ${media.url}"),
            ],
          );
        }
      },
    );
  }
}
