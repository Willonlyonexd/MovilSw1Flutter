import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            Lottie.asset(
              'assets/lottie/Tareaslottie.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            // Texto indicando que no hay tareas
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'De momento no hay tareas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
