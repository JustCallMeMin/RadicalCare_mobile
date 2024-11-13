import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/vehicle.dart';

const String baseUrl = 'http://192.168.1.33:8080/api/v1'; // URL gốc của API

// Hàm để lấy danh sách tìm kiếm gần đây
Future<List<String>> fetchRecentSearches() async {
  try {
    final uri = Uri.parse('$baseUrl/search/get?userId=anonymous');
    print('Fetching recent searches from: $uri'); // Debug URL
    final response = await http.get(uri);
    print('API Response: ${response.body}'); // Debug API response

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetched recent searches: ${data['data']}'); // Debug parsed data
      return List<String>.from(data['data']);
    } else {
      throw Exception('Failed to load recent searches: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in fetchRecentSearches: $e'); // Debug error
    throw Exception('Error fetching recent searches: $e');
  }
}


// Hàm để xóa toàn bộ tìm kiếm gần đây
Future<void> clearAllRecentSearches() async {
  try {
    final response = await http.delete(Uri.parse('$baseUrl/search/delete?userId=anonymous'));
    if (response.statusCode != 200) {
      throw Exception('Failed to clear recent searches: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error clearing recent searches: $e');
  }
}

// Hàm để xóa một tìm kiếm gần đây
Future<void> removeRecentSearch(String keyword) async {
  const String apiUrl = '$baseUrl/search/delete';
  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': 'anonymous', // Đảm bảo giá trị userId là đúng
        'searchText': keyword, // Từ khóa tìm kiếm để xóa
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully removed recent search: $keyword');
    } else {
      throw Exception('Failed to remove recent search: ${response.statusCode}');
    }
  } catch (e) {
    print('Error removing recent search: $e');
    throw Exception('Error removing recent search: $e');
  }
}


// Hàm để thực hiện tìm kiếm các phương tiện theo từ khóa
Future<List<Vehicle>> fetchVehiclesByKeyword(String keyword) async {
  final String apiUrl = '$baseUrl/search/vehicles?keyword=$keyword';
  try {
    print('Gửi yêu cầu tới API: $apiUrl'); // Debug
    final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));
    print('Phản hồi từ API: ${response.body}'); // Debug phản hồi

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> vehiclesData = jsonResponse['data'];
      print('Danh sách vehicles: $vehiclesData'); // Debug dữ liệu vehicles
      return vehiclesData.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles by keyword. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Lỗi khi gọi API: $error'); // Debug lỗi
    throw Exception('Error fetching vehicles by keyword: $error');
  }
}

Future<double> fetchBaseCostByCostId(int costId) async {
  final String apiUrl = '$baseUrl/costs/$costId';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['baseCost'] ?? 0.0;
    } else {
      throw Exception('Failed to fetch base cost for costId: $costId');
    }
  } catch (e) {
    throw Exception('Error fetching base cost: $e');
  }
}
