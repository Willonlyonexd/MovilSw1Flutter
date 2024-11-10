import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fondo más suave
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.teal, // Color del AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Espacio entre el texto y el botón
           ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/login');
  },
  child: Text('Go to Login Screen'),
),
          ],
        ),
      ),
    );
  }
}
