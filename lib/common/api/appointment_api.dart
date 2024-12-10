import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';
import 'api_config.dart';

class AppointmentApi {
  /// Fetch all appointments
  static Future<Map<String, dynamic>> fetchAllAppointments() async {
    final url = Uri.parse('$baseUrl/appointments');

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
      throw Exception(
          'Failed to fetch appointments: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Fetch appointment by ID
  static Future<Map<String, dynamic>> fetchAppointmentById(int id) async {
    final url = Uri.parse('$baseUrl/appointments/$id');

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
      throw Exception('Appointment not found');
    } else {
      throw Exception(
          'Failed to fetch appointment: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Create a new appointment
  static Future<void> createAppointment(Map<String, dynamic> appointmentData) async {
    final url = Uri.parse('$baseUrl/appointments/create');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to create appointment: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Search appointments
  static Future<Map<String, dynamic>> searchAppointments({
    String? customerId,
    String? dateCreated,
    List<String>? serviceIds,
  }) async {
    final queryParams = {
      if (customerId != null) 'customerId': customerId,
      if (dateCreated != null) 'dateCreated': dateCreated,
      if (serviceIds != null) 'serviceIds': serviceIds.join(','),
    };

    final url = Uri.parse('$baseUrl/appointments/search').replace(queryParameters: queryParams);

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
      throw Exception(
          'Failed to search appointments: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Update an appointment by ID
  static Future<void> updateAppointment(String id, Map<String, dynamic> appointmentData) async {
    final url = Uri.parse('$baseUrl/appointments/$id');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update appointment: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Delete an appointment by ID
  static Future<void> deleteAppointment(String id) async {
    final url = Uri.parse('$baseUrl/appointments/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete appointment: ${response.reasonPhrase} (${response.statusCode})');
    }
  }
}
