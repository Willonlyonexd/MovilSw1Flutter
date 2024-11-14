import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login_screen.dart';

class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Usuario';
      userEmail = prefs.getString('user_email') ?? 'Correo no disponible';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Elimina todos los datos guardados

    // Navegar a la pantalla de inicio de sesión y eliminar el historial de navegación
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 34, 56, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Lottie.asset(
              'assets/lottie/usertop.json',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Divider(color: Colors.white70),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Configuración', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Aquí puedes añadir la lógica para abrir la configuración
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.white),
              title: Text('Cambiar Contraseña', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Aquí puedes añadir la lógica para cambiar la contraseña
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              onTap: _logout,
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/lottie/userdown.json',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'Gracias por ser parte de nuestra comunidad educativa',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
