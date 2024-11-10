import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 23, 43, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Animación y saludo en la misma línea
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animación de Lottie
                    Lottie.asset(
                      'assets/lottie/Animation - saludo.json',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10), // Espacio entre animación y texto
                    // Texto de saludo
                    const Expanded(
                      child: Text(
                        'Hola Bienvenido: (nombre de usuario)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Carrusel de anuncios
                CarouselSlider(
                  options: CarouselOptions(
                    height: 250, // Tamaño del carrusel
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                  ),
                  items: [
                    'Anuncio 1',
                    'Anuncio 2',
                    'Anuncio 3',
                  ].map((anuncio) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              anuncio,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Tareas pendientes
                const Text(
                  'Tareas pendientes:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F222A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'Lista de tareas pendientes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Progreso de materias
                const Text(
                  'Progreso de materias:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),
                _buildProgressList(), // Visualización del progreso
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir la lista de progreso
  Widget _buildProgressList() {
    final List<Map<String, dynamic>> materias = [
      {'materia': 'Matemáticas', 'progreso': 0.8},
      {'materia': 'Ciencias', 'progreso': 0.6},
      {'materia': 'Lenguaje', 'progreso': 0.9},
      {'materia': 'Historia', 'progreso': 0.7},
      {'materia': 'Educación Física', 'progreso': 0.5},
    ];

    return ListView.builder(
      shrinkWrap: true, // Para evitar overflow
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia['materia'],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: materia['progreso'],
                minHeight: 10,
                backgroundColor: Colors.grey,
                color: Colors.yellow,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
