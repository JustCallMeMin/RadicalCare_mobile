import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/cost_table.dart';
import '../model/vehicle.dart';

const String baseUrl = 'http://192.168.2.14:8080/api/v1'; // Base URL của API

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
  final url = Uri.parse("$baseUrl/category");
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

// Helper function to build query strings for search parameters
String buildQueryString(Map<String, dynamic> params) {
  return params.entries
      .where((entry) => entry.value != null)
      .map((entry) {
    if (entry.value is List) {
      return '${entry.key}=${(entry.value as List).join(',')}';
    }
    return '${entry.key}=${entry.value}';
  })
      .join('&');
}

// Function to fetch vehicles with filters
Future<List<Vehicle>> fetchVehicles({
  String? keyword,
  int page = 0,
  int size = 10,
  String sortBy = 'chassisNumber',
  List<String>? segments,
  List<String>? colors,
  bool? sold,
  List<int>? categoryIds,
  double? minCost,
  double? maxCost,
  String? userId,
}) async {
  final queryParams = {
    'keyword': keyword,
    'page': page,
    'size': size,
    'sortBy': sortBy,
    'segments': segments,
    'colors': colors,
    'sold': sold,
    'categoryIds': categoryIds,
    'minCost': minCost,
    'maxCost': maxCost,
    'userId': userId,
  };

  final String queryString = buildQueryString(queryParams);
  final String apiUrl = '$baseUrl/vehicles?$queryString';

  final token = await getToken();
  if (token == null) throw Exception("User not logged in.");

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> vehiclesData = data['data']; // Assuming API returns data under "data"

      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to load vehicles. $errorMessage');
    }
  } catch (error) {
    throw Exception('Error fetching vehicles: $error');
  }
}

// Function to fetch a single vehicle by ID
Future<Vehicle> fetchVehicleById(String id) async {
  final String apiUrl = '$baseUrl/vehicle/$id';
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
  final String apiUrl = '$baseUrl/vehicles/by-ids';
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
  final String apiUrl = '$baseUrl/cost-table/$id';
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
