import 'package:flutter/material.dart';
import '../models/comunicado.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  late Future<List<Comunicado>> futureComunicados;

  @override
  void initState() {
    super.initState();
    futureComunicados = ApiService().fetchComunicados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunicados'),
      ),
      body: FutureBuilder<List<Comunicado>>(
        future: futureComunicados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay comunicados disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Comunicado comunicado = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(comunicado.nombre),
                    subtitle: Text(comunicado.descripcion),
                    trailing: Text(comunicado.fecha),
                    onTap: () {
                      _showMultimediaOptions(comunicado.multimedia);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showMultimediaOptions(List<Multimedia> multimediaList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: multimediaList.length,
          itemBuilder: (context, index) {
            Multimedia multimedia = multimediaList[index];
            return ListTile(
              leading: Icon(_getIconForType(multimedia.type)),
              title: Text(multimedia.name),
              onTap: () {
                _launchURL(multimedia.url);
              },
            );
          },
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    if (type.startsWith('image')) {
      return Icons.image;
    } else if (type.startsWith('video')) {
      return Icons.videocam;
    } else if (type.startsWith('audio')) {
      return Icons.audiotrack;
    } else {
      return Icons.insert_drive_file;
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
