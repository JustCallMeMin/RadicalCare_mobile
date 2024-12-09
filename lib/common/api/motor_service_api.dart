import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';
import 'api_config.dart';

class MotorServiceApi {
  /// Fetch all motor services
  static Future<Map<String, dynamic>> fetchAllMotorServices() async {
    final url = Uri.parse('$baseUrl/motor-service');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch motor services: ${response.reasonPhrase}');
    }
  }

  /// Fetch motor service by ID
  static Future<Map<String, dynamic>> fetchMotorServiceById(String id) async {
    final url = Uri.parse('$baseUrl/motor-service/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Motor service not found');
    } else {
      throw Exception(
          'Failed to fetch motor service: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Create a new motor service
  static Future<void> createMotorService(Map<String, dynamic> motorServiceData) async {
    final url = Uri.parse('$baseUrl/motor-service');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(motorServiceData),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to create motor service: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Update an existing motor service by ID
  static Future<void> updateMotorService(
      String id, Map<String, dynamic> motorServiceData) async {
    final url = Uri.parse('$baseUrl/motor-service/$id');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(motorServiceData),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to update motor service: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Delete a motor service by ID
  static Future<void> deleteMotorService(String id) async {
    final url = Uri.parse('$baseUrl/motor-service/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete motor service: ${response.reasonPhrase} (${response.statusCode})');
    }
  }
}
