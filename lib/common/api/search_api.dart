import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vehicle.dart';

const String baseUrl = 'http://192.168.1.33:8080/api/v1'; // Đặt URL gốc của API

// Hàm để lấy danh sách tìm kiếm gần đây
Future<List<String>> fetchRecentSearches() async {
  const String apiUrl = '$baseUrl/search/recent'; // API endpoint cho tìm kiếm gần đây
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<String> recentSearches = List<String>.from(jsonResponse['data']);
      return recentSearches;
    } else {
      throw Exception('Failed to load recent searches. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching recent searches: $error');
  }
}

// Hàm để thực hiện tìm kiếm các phương tiện theo từ khóa
Future<List<Vehicle>> fetchVehiclesByKeyword(String keyword) async {
  final response = await http.get(Uri.parse('$baseUrl/search/vehicles?keyword=$keyword'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<Vehicle> vehicles = (data['data'] as List)
        .map((vehicle) => Vehicle.fromJson(vehicle))
        .toList();
    return vehicles;
  } else {
    throw Exception('Failed to load vehicles by keyword');
  }
}
