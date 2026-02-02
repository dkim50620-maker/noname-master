import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userPrefix = 'user_';
  static const String _currentUserKey = 'current_user_login';

  // Хэширование пароля (SHA-256)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Регистрация нового пользователя
  Future<String?> register(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (prefs.containsKey('$_userPrefix$login')) {
      return 'Пользователь с таким логином уже существует';
    }

    await prefs.setString('$_userPrefix$login', _hashPassword(password));
    return null;
  }

  // Вход в систему
  Future<bool> login(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    final storedHash = prefs.getString('$_userPrefix$login');
    if (storedHash == null) {
      return false;
    }

    if (storedHash == _hashPassword(password)) {
      await prefs.setString(_currentUserKey, login);
      return true;
    }
    return false;
  }

  // Выход из системы
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Получение текущего пользователя
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }
}
