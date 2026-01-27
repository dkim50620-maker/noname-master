class AuthService {
  // Локальные данные пользователя
  static String currentEmail = 'eve.holt@reqres.in';
  static String currentPassword = 'cityslicka';
  static String token = 'fake-token-123';

  // Логин
  static Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.trim() == currentEmail && password.trim() == currentPassword) {
      return token;
    }
    return null;
  }

  // Смена email
  static Future<bool> changeEmail(String tokenProvided, String newEmail) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (tokenProvided == token) {
      currentEmail = newEmail;
      return true;
    }
    return false;
  }

  // Смена пароля
  static Future<bool> changePassword(String tokenProvided, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (tokenProvided == token) {
      currentPassword = newPassword;
      return true;
    }
    return false;
  }
}
