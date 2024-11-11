import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/login': (BuildContext context) => LoginScreen(),
    '/dashboard': (BuildContext context) => DashboardScreen(),
  };
}
