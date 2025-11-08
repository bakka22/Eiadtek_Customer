import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/auth.dart';
import 'dart:math';

class ClinicService {
  // Existing base URLs
  static const String baseUrl =
      "https://nonlacteous-percussively-dylan.ngrok-free.dev";

  static const String clinicsUrl = "$baseUrl/clinics";

  static const String statesUrl =
      "$baseUrl/states/";

  // ✅ New endpoints
  static const String contactInfoUrl =
      "$baseUrl/contact_info/";
  static const String recommendationsUrl =
      "$baseUrl/recommendation/";

  /// Get clinics filtered by state, city, and optional specialty
  static Future<List<dynamic>> getClinics({
    required String state,
    required String city,
    String? specialty,
    String? type,
  }) async {
    final uri = Uri.parse(clinicsUrl);
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
    final uri = Uri.parse("$clinicsUrl$id");
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

  // 📨 NEW: Fetch contact info (GET)
  static Future<Map<String, dynamic>> getContactInfo() async {
    final uri = Uri.parse(contactInfoUrl);
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User not authenticated. Token not found.");
    }

    final headers = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Assuming only one contact info record exists
      return data.isNotEmpty ? data.first : {};
    } else {
      throw Exception(
        "Failed to fetch contact info: ${response.statusCode} - ${response.body}",
      );
    }
  }

  // 💬 NEW: Send a recommendation (POST)
  static Future<void> sendRecommendation(String content) async {
    final uri = Uri.parse(recommendationsUrl);
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User not authenticated. Token not found.");
    }

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "content": content,
    });

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        "Failed to send recommendation: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
