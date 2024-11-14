import 'package:flutter/material.dart';
import '../views/dashboard_screen.dart';
import '../views/login_screen.dart';
import '../views/AgendaScreen.dart';
import '../views/comunicado_screen.dart';
import '../views/usuario_screen.dart';
import '../views/NotificacionesScreen.dart';
//import '../views/comunicado_detail_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/login': (BuildContext context) => LoginScreen(),
    '/dashboard': (BuildContext context) => DashboardScreen(),
    '/agenda': (BuildContext context) => AgendaScreen(),
    '/comunicados': (BuildContext context) => ComunicadoScreen(),
    '/usuarios': (BuildContext context) => UsuarioScreen(),
    '/notificaciones': (BuildContext context) => NotificacionesScreen(),

  };
}
