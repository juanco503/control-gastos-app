import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// Registra un nuevo usuario si no existe
  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(username)) return false;

    bool success = await prefs.setString(username, password);
    return success;
  }

  /// Verifica credenciales de login
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString(username);

    if (storedPassword == null) return false; // Usuario no existe
    return storedPassword == password;        // Compara contraseñas
  }

  /// Actualiza la contraseña del usuario si existe
  Future<bool> updateUser(String username, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(username)) return false;

    bool success = await prefs.setString(username, newPassword);
    return success;
  }

  /// Elimina un usuario si existe
  Future<bool> deleteUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(username)) return false;

    bool success = await prefs.remove(username);
    return success;
  }
}