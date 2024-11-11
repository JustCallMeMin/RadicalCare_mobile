import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cost_table.dart';
import '../model/vehicle.dart';

const String baseUrl = 'http://192.168.1.33:8080/api/v1'; // Đặt URL gốc của API

// Hàm để lấy danh mục
Future<List<String>> fetchCategories() async {
  const String apiUrl = '$baseUrl/category';
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> categories = jsonResponse['data'];

      return categories.map((category) => category['name'].toString()).toList();
    } else {
      throw Exception('Failed to load categories. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching categories: $error');
  }
}

// Hàm để lấy danh sách phương tiện
Future<List<Vehicle>> fetchVehicles() async {
  const String apiUrl = '$baseUrl/vehicle';
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> vehiclesData = jsonResponse['data'];

      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching vehicles: $error');
  }
}

// Hàm để lấy chi tiết sản phẩm theo ID
Future<Vehicle> fetchVehicleById(String id) async {
  final String apiUrl = '$baseUrl/vehicle/$id';
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to load product details. Status code: ${response.statusCode}');
    }

    final jsonResponse = json.decode(response.body);
    if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
      final vehicleData = jsonResponse['data'] as Map<String, dynamic>;
      if (vehicleData.isNotEmpty) {
        return Vehicle.fromJson(vehicleData);
      }
      throw Exception('No data found for vehicle with id $id');
    } else {
      throw Exception('Invalid JSON format or missing "data" key for vehicle with id $id');
    }
  } catch (error) {
    throw Exception('Error fetching product details: $error');
  }
}
// Hàm để lấy danh sách phương tiện theo danh sách ID
Future<List<Vehicle>> fetchVehiclesByIds(List<String> ids) async {
  const String apiUrl = '$baseUrl/vehicles/by-ids';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': ids}), // Gửi danh sách ID dưới dạng JSON
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> vehiclesData = jsonResponse['data'];

      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles by IDs. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching vehicles by IDs: $error');
  }
}

// Hàm để lấy chi tiết chi phí theo ID
Future<CostTable> fetchCostById(int id) async {
  final String apiUrl = '$baseUrl/cost-table/$id';
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return CostTable.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load cost information. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching cost information: $error');
  }
}

