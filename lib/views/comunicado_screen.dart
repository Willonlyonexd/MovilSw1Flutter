import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/comunicado_model.dart';
import '../services/api_service.dart';
import 'comunicado_detail_screen.dart';

class ComunicadoScreen extends StatefulWidget {
  @override
  _ComunicadoScreenState createState() => _ComunicadoScreenState();
}

class _ComunicadoScreenState extends State<ComunicadoScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Comunicado>> _comunicadosFuture;

  @override
  void initState() {
    super.initState();
    _comunicadosFuture = _apiService.getComunicados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8), // Espacio entre el texto y la animación
            Lottie.asset(
              'assets/lottie/Animation - 1731532700318-notificacion.json',
              width: 40, // Tamaño pequeño para el Lottie en la AppBar
              height: 40,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/agenda');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Comunicado>>(
        future: _comunicadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/Animation - 1731532700318-notificacion.json',
                width: 200, // Tamaño más grande
                height: 200,
                fit: BoxFit.cover,
                repeat: true, // Repetir la animación indefinidamente
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hay comunicados disponibles.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Comunicado comunicado = snapshot.data![index];
                return Card(
                  color: const Color.fromRGBO(42, 44, 66, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      comunicado.nombre,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      comunicado.descripcion,
                      style: TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      comunicado.visto ? Icons.check_circle : Icons.visibility_off,
                      color: comunicado.visto ? Colors.greenAccent : Colors.redAccent,
                    ),
                    onTap: () async {
                      // Cambiar el estado de "visto" al abrir el comunicado
                      setState(() {
                        comunicado.visto = true;
                      });

                      // Navegar a la pantalla de detalles
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComunicadoDetailScreen(comunicado: comunicado),
                        ),
                      );
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
}
