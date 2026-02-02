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

    String hashedPassword = _hashPassword(password);
    
    // ДОБАВЛЕНО ДЛЯ ПРОВЕРКИ:
    print('--- РЕГИСТРАЦИЯ ---');
    print('Логин: $login');
    print('Введенный пароль: $password');
    print('Хэш, который будет сохранен: $hashedPassword');
    print('-------------------');

    await prefs.setString('$_userPrefix$login', hashedPassword);
    return null;
  }

  // Вход в систему
  Future<bool> login(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    final storedHash = prefs.getString('$_userPrefix$login');
    if (storedHash == null) {
      return false;
    }

    String enteredHash = _hashPassword(password);

    // ДОБАВЛЕНО ДЛЯ ПРОВЕРКИ:
    print('--- ВХОД В СИСТЕМУ ---');
    print('Логин: $login');
    print('Сохраненный хэш в памяти: $storedHash');
    print('Хэш введенного сейчас пароля: $enteredHash');
    print('Результат сравнения: ${storedHash == enteredHash}');
    print('----------------------');

    if (storedHash == enteredHash) {
      await prefs.setString(_currentUserKey, login);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }
}
