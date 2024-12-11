import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/secure_storage.dart';
import 'api_config.dart';

class GpsApi {
  static Future<void> saveGpsLocation({
    required String latitude,
    required String longitude,
    required String userId,
    String? customerId,
    required String timestamp, // Thêm timestamp
  }) async {
    final url = Uri.parse("${baseUrl}/gps");

    // Tạo body gửi lên BE
    final body = {
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": timestamp, // Thêm timestamp vào body
      "user": {"id": userId},
      if (customerId != null) "customer": {"id": customerId},
    };

    // Gửi yêu cầu POST
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception(
        "Failed to save GPS location: ${response.reasonPhrase} (${response.statusCode})",
      );
    }
  }

  // Lấy vị trí GPS (giữ nguyên)
  static Future<Map<String, dynamic>> fetchGpsLocation() async {
    final userId = await SecureStorageManager.getUserId();
    if (userId == null) {
      throw Exception("User ID not found in storage");
    }

    final url = Uri.parse("${baseUrl}/gps/$userId");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception(
        "Failed to fetch GPS location: ${response.reasonPhrase} (${response.statusCode})",
      );
    }
  }
}

