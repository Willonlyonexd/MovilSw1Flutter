import 'package:flutter/material.dart';
import '../models/comunicado.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Comunicado>> comunicadosFuture;

  @override
  void initState() {
    super.initState();
    comunicadosFuture = ApiService().fetchComunicados(); // Llama a la función que obtiene los comunicados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comunicados")),
      body: FutureBuilder<List<Comunicado>>(
        future: comunicadosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay comunicados"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final comunicado = snapshot.data![index];
                return ListTile(
                  title: Text(comunicado.nombre),
                  subtitle: Text(comunicado.descripcion),
                  onTap: () {
                    // Lógica para abrir el link en un navegador, si corresponde
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
