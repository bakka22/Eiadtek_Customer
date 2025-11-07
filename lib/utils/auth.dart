import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for authentication actions such as register and login.
/// Place this file under `lib/utils/auth.dart`.
class AuthService {
  static const String baseUrl =
      'https://nonlacteous-percussively-dylan.ngrok-free.dev/auth';

  /// Registers a new user by sending a JSON body to FastAPI.
  static Future<int> registerUser({
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'role': role}),
      );

      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 2;
    }
  }

  /// Logs in a user by sending form data to FastAPI.
  /// If successful, stores the token in SharedPreferences.
  static Future<int> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Store the access token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('token_type', data['token_type']);

        return response.statusCode; // success
      } else {
        return response.statusCode; // invalid credentials
      }
    } catch (e) {
      return 2; // network or unexpected error
    }
  }

  /// Retrieves the stored token (returns null if not found)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}
