import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/cost_table_model.dart';
import '../model/vehicle_model.dart';
import 'api_config.dart';

// Secure Storage for token
final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

// Helper function to get the token from Secure Storage
Future<String?> getToken() async {
  try {
    final token = await _secureStorage.read(key: 'auth_token');
    return token;
  } catch (e) {
    print("Error retrieving token: $e");
    return null;
  }
}

// Function to fetch categories
Future<Map<String, dynamic>> fetchCategories() async {
  final url = Uri.parse("${baseUrl}/category");
  final token = await getToken();

  if (token == null) {
    return {
      "success": false,
      "message": "User is not logged in.",
    };
  }

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "success": true,
        "data": data['data'], // Assuming API returns data under "data"
      };
    } else {
      print("Error response: ${response.body}");
      return {
        "success": false,
        "message": jsonDecode(response.body)['message'] ?? 'Failed to fetch categories',
      };
    }
  } catch (error) {
    print("Error fetching categories: $error");
    return {
      "success": false,
      "message": "An error occurred: $error",
    };
  }
}

// Thêm hàm fetchAllVehicles
Future<List<Vehicle>> fetchAllVehicles({String sortBy = 'chassisNumber'}) async {
  final String apiUrl = '${baseUrl}/vehicles/all?sortBy=$sortBy';

  final token = await getToken();
  if (token == null) throw Exception("User not logged in.");

  try {
    print("Fetching all vehicles from: $apiUrl"); // Log URL
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> vehiclesData = data['data'];

      print("Fetched all vehicles count: ${vehiclesData.length}");
      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      print("Error fetching all vehicles: $errorMessage");
      throw Exception('Failed to load all vehicles. $errorMessage');
    }
  } catch (error) {
    print("Error fetching all vehicles: $error");
    throw Exception('Error fetching all vehicles: $error');
  }
}
// Function to fetch a single vehicle by ID
Future<Vehicle> fetchVehicleById(String id) async {
  final String apiUrl = '${baseUrl}/vehicle/$id';
  final token = await getToken();

  if (token == null) throw Exception("User not logged in.");

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Vehicle.fromJson(data['data']); // Assuming API returns data under "data"
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load vehicle details. $errorMessage');
    }
  } catch (error) {
    throw Exception('Error fetching vehicle details: $error');
  }
}

// Function to fetch multiple vehicles by IDs
Future<List<Vehicle>> fetchVehiclesByIds(List<String> ids) async {
  final String apiUrl = '${baseUrl}/vehicles/by-ids';
  final token = await getToken();

  if (token == null) throw Exception("User not logged in.");

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(ids),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> vehiclesData = data['data']; // Assuming API returns data under "data"

      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load vehicles by IDs. $errorMessage');
    }
  } catch (error) {
    throw Exception('Error fetching vehicles by IDs: $error');
  }
}

// Function to fetch cost details by ID
Future<CostTable> fetchCostById(int id) async {
  final String apiUrl = '${baseUrl}/cost-table/$id';
  final token = await getToken();

  if (token == null) throw Exception("User not logged in.");

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CostTable.fromJson(data['data']); // Assuming API returns data under "data"
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load cost details. $errorMessage');
    }
  } catch (error) {
    throw Exception('Error fetching cost details: $error');
  }
}