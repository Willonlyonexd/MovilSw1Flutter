import 'package:flutter/material.dart';
import 'screens/dashboard_navigation.dart';
import 'screens/login_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/login': (BuildContext context) => LoginScreen(),
    '/dashboard': (BuildContext context) => DashboardNavigation(), // Uso de DashboardNavigation
  };
}