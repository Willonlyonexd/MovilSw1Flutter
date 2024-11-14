import 'package:flutter/material.dart';
import '../views/AgendaScreen.dart';
import 'dashboard_screen.dart';
import 'eventos_screen.dart';
import '../views/usuario_screen.dart';
import '../views/comunicado_screen.dart';


class DashboardNavigation extends StatefulWidget {
  @override
  _DashboardNavigationState createState() => _DashboardNavigationState();
}

class _DashboardNavigationState extends State<DashboardNavigation> {
  int _selectedIndex = 0; // Controla qué pantalla se muestra

  final List<Widget> _pages = [
    DashboardScreen(),
    AgendaScreen(),
    EventosScreen(),
    ComunicadoScreen(),
    UsuarioScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cambia la vista seleccionada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Muestra la vista seleccionada
        children: _pages,
      ),
      backgroundColor: const Color(0xFF15172B),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1F222A),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Eventos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Usuario',
            ),
          ],
        ),
      ),
    );
  }
}
