import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vehicle_model.dart';
import 'api_config.dart';

/// Hàm để lấy danh mục
Future<List<Map<String, dynamic>>> fetchCategoriesWithId(String token) async {
  final String apiUrl = '${baseUrl}/category'; // API endpoint
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> categoriesData = jsonResponse['data'];

      // Trả về danh sách map chứa cả id và name
      return categoriesData.map((category) {
        return {
          'id': category['id'], // Lấy categoryId
          'name': category['name'], // Lấy tên category
        };
      }).toList();
    } else {
      throw Exception('Failed to load categories. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching categories: $error');
  }
}

/// Hàm để lấy danh sách phân khúc (segments)
Future<List<String>> fetchSegments(String token) async {
  final String apiUrl = '${baseUrl}/filter/segments';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((segment) => segment as String).toList();
    } else {
      throw Exception('Failed to load segments. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching segments: $error');
  }
}

/// Hàm để lấy danh sách màu sắc (colors)
Future<List<String>> fetchColors(String token) async {
  final String apiUrl = '${baseUrl}/filter/colors';
  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((color) => color as String).toList();
    } else {
      throw Exception('Failed to load colors. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching colors: $error');
  }
}

/// Hàm gọi API để lọc các phương tiện (vehicles)
Future<List<Map<String, dynamic>>> fetchFilteredVehicles({
  required String token,
  List<String>? segments,
  List<String>? colors,
  bool? sold,
  List<int>? categoryIds,
  double? minCost,
  double? maxCost,
}) async {
  final queryParams = <String, List<String>>{};

  // Hàm phụ để thêm tham số vào queryParams nếu có giá trị
  void addQueryParam(String key, List<String>? values) {
    if (values != null && values.isNotEmpty) {
      queryParams[key] = values;
    }
  }

  // Thêm các tham số vào queryParams
  addQueryParam('segment', segments);
  addQueryParam('color', colors);
  addQueryParam('sold', sold != null ? [sold.toString()] : null);
  addQueryParam('categoryId', categoryIds?.map((id) => id.toString()).toList());
  addQueryParam('minCost', minCost != null ? [minCost.toString()] : null);
  addQueryParam('maxCost', maxCost != null ? [maxCost.toString()] : null);

  final uri = Uri.parse('${baseUrl}/filter').replace(queryParameters: queryParams);

  print("Request URI: $uri"); // Log để kiểm tra URI

  try {
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load filtered vehicles. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error fetching filtered vehicles: $error');
  }
}