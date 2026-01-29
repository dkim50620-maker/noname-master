import 'dart:convert';
import 'package:http/http.dart' as http;

class SupportService {
  static const String _url = 'https://formspree.io/f/xlgnjbqa';

  static Future<bool> sendMessage({
    required String email,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'message': message,
      }),
    );

    return response.statusCode == 200;
  }
}
