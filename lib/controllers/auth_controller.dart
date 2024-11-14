import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/token_manager.dart';

class AuthController {
  final ApiService _apiService = ApiService();

  Future<bool> login(String username, String password) async {
    try {
      User? user = await _apiService.login(username, password);
      if (user != null) {
        await TokenManager.saveToken(user.token);  // Guardar token para futuras solicitudes
        
        // Guardar el nombre de usuario y correo electrónico en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', user.name); // Guardar nombre de usuario
        await prefs.setString('user_email', user.email); // Guardar correo electrónico

        return true;
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }
}
