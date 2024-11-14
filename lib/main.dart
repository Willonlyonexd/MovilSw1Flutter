import 'package:flutter/material.dart';
import './routes/app_routes.dart'; // Asumiendo que tus rutas están en un archivo separado
import 'views/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: getApplicationRoutes(),
    );
  }
}
