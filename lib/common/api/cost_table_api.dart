import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';
import 'api_config.dart';

class CostApi {
  // Fetch base cost by costId
  static Future<double> fetchBaseCostById(int costId) async {
    final token = await SecureStorageManager.getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final url = Uri.parse('$baseUrl/cost-table/$costId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic> &&
          data['data']['baseCost'] is num) {
        return data['data']['baseCost'].toDouble();
      } else {
        throw Exception("Invalid response structure: $data");
      }
    } else {
      throw Exception('Failed to fetch cost: ${response.statusCode}');
    }
  }
}
