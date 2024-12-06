import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vehicle.dart';

const String baseUrl = 'http://192.168.2.14:8080/api/v1'; // Đặt URL gốc của API

// Hàm để lấy danh mục
Future<List<Map<String, dynamic>>> fetchCategoriesWithId() async {
  const String apiUrl = '$baseUrl/category'; // API endpoint
  try {
    final response = await http.get(Uri.parse(apiUrl)).timeout(Duration(seconds: 10));

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


// Hàm để lấy danh sách phân khúc (segments)
Future<List<String>> fetchSegments() async {
  const String apiUrl = '$baseUrl/filter/segments';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'] as List;
    return data.map((segment) => segment as String).toList();
  } else {
    throw Exception('Failed to load segments');
  }
}

// Hàm để lấy danh sách màu sắc (colors)
Future<List<String>> fetchColors() async {
  const String apiUrl = '$baseUrl/filter/colors';
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'] as List;
    return data.map((color) => color as String).toList();
  } else {
    throw Exception('Failed to load colors');
  }
}

// Hàm gọi API để lọc các phương tiện (vehicles)
Future<List<Map<String, dynamic>>> fetchFilteredVehicles({
  List<String>? segments,
  List<String>? colors,
  bool? sold,
  List<int>? categoryIds,
  double? minCost,
  double? maxCost,
}) async {
  // Khởi tạo Map cho query params với hỗ trợ đa giá trị
  final queryParams = <String, List<String>>{};

  // Hàm phụ để thêm tham số vào queryParams nếu có giá trị
  void addQueryParam(String key, List<String>? values) {
    if (values != null && values.isNotEmpty) {
      queryParams[key] = values;
    }
  }

  // Sử dụng hàm phụ để thêm các tham số vào queryParams
  addQueryParam('segment', segments);
  addQueryParam('color', colors);
  addQueryParam('sold', sold != null ? [sold.toString()] : null);
  addQueryParam('categoryId', categoryIds?.map((id) => id.toString()).toList());
  addQueryParam('minCost', minCost != null ? [minCost.toString()] : null);
  addQueryParam('maxCost', maxCost != null ? [maxCost.toString()] : null);

  // Tạo URI với các query params hỗ trợ đa giá trị
  final uri = Uri.http('192.168.1.33:8080', '/api/v1/filter', queryParams);
  print("Request URI: $uri"); // Log để kiểm tra URI

  try {
    final response = await http.get(uri).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load filtered vehicles');
    }
  } catch (error) {
    throw Exception('Error fetching filtered vehicles: $error');
  }
}

