import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/auth.dart'; // import AuthService to get the token
import 'dart:math';

class ClinicService {
  // Change this to your ngrok/public/laptop IP when testing externally
  static const String baseUrl =
      "https://nonlacteous-percussively-dylan.ngrok-free.dev/clinics/";
  static const String statesUrl =
      "https://nonlacteous-percussively-dylan.ngrok-free.dev/states/";

  /// Get clinics filtered by state, city, and optional specialty
  static Future<List<dynamic>> getClinics({
    required String state,
    required String city,
    String? specialty,
    String? type,
  }) async {
    final uri = Uri.parse(baseUrl);

    // Retrieve token from SharedPreferences
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User not authenticated. Token not found.");
    }

    final headers = {
      "Authorization": "Bearer $token",
      "X-State": state,
      "X-City": city,
      if (specialty != null && specialty.isNotEmpty) "X-Specialty": specialty,
      if (type != null && type.isNotEmpty) "X-type": type,
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> clinics = jsonDecode(response.body);
      clinics.shuffle(Random());
      return clinics;
    } else {
      throw Exception(
        "Failed to fetch clinics: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Get a single clinic by ID
  static Future<Map<String, dynamic>> getClinicById({
    required String id,
  }) async {
    final uri = Uri.parse("$baseUrl$id");

    // Retrieve token from SharedPreferences
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User not authenticated. Token not found.");
    }

    final headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to fetch clinic by ID: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Get all states with their cities
  static Future<List<dynamic>> getStatesWithCities() async {
    final uri = Uri.parse(statesUrl);

    // Retrieve token from SharedPreferences
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User not authenticated. Token not found.");
    }

    final headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to fetch states: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
