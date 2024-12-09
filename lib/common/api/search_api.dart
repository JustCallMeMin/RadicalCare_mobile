import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vehicle.dart';
import '../utils/secure_storage.dart';
import 'api_config.dart'; // Token retrieval utility

/// Lấy danh sách tìm kiếm gần đây
Future<List<String>> fetchRecentSearches(String userId) async {
  try {
    final token = await SecureStorageManager.getToken(); // Lấy token từ storage
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/search/recent?userId=$userId');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'}, // Thêm Authorization header
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['data']);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized - Token không hợp lệ hoặc đã hết hạn.");
    } else {
      throw Exception('Failed to load recent searches: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching recent searches: $e');
  }
}

/// Xóa toàn bộ tìm kiếm gần đây
Future<void> clearAllRecentSearches(String userId) async {
  try {
    final token = await SecureStorageManager.getToken(); // Lấy token từ storage
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/search/clear/recent?userId=$userId');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token', // Gửi JWT trong header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear recent searches: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error clearing recent searches: $e');
  }
}

/// Xóa một tìm kiếm gần đây
Future<void> removeRecentSearch(String userId, String keyword) async {
  try {
    final token = await SecureStorageManager.getToken(); // Lấy token từ storage
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/search/delete/recent?userId=$userId');
    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token', // Gửi JWT trong header
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'searchText': keyword, // Từ khóa cần xóa
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove recent search: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error removing recent search: $e');
  }
}

/// Tìm kiếm phương tiện theo từ khóa
Future<List<Vehicle>> fetchVehiclesByKeyword(String keyword, String userId) async {
  try {
    final token = await SecureStorageManager.getToken(); // Lấy token từ storage
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse(
        '${baseUrl}/vehicles/search?keyword=$keyword&userId=$userId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token', // Gửi JWT trong header
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> vehiclesData = jsonResponse['data'];
      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to fetch vehicles: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching vehicles: $e');
  }
}