import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../utils/secure_storage.dart';
import 'api_config.dart'; // Token retrieval utility

/// Lấy thông tin người dùng hiện tại
Future<User> fetchUserInfo() async {
  try {
    print("[HomeAPI] Fetching user info");

    final token = await SecureStorageManager.getToken();
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/auth/fetch-user');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      print("[HomeAPI] User info fetched successfully: $jsonResponse");
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    print("[HomeAPI] Error fetching user info: $e");
    throw Exception('Error fetching user info: $e');
  }
}

/// Gửi dữ liệu GPS lên server
Future<void> postGpsData({
  required String userId,
  String? customerId,
  required double latitude,
  required double longitude,
}) async {
  try {
    print("[HomeAPI] Posting GPS data: userId=$userId, latitude=$latitude, longitude=$longitude");

    final token = await SecureStorageManager.getToken();
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/gps');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user': {'id': userId},
        'customer': customerId != null ? {'id': customerId} : null,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(), // Thêm timestamp
      }),
    );

    if (response.statusCode == 201) {
      print("[HomeAPI] GPS data posted successfully");
    } else {
      final responseBody = json.decode(response.body);
      throw Exception('Failed to post GPS data: ${responseBody['message']}');
    }
  } catch (e) {
    print("[HomeAPI] Error posting GPS data: $e");
    throw Exception('Error posting GPS data: $e');
  }
}

/// Lấy dữ liệu GPS từ server
Future<Map<String, dynamic>> fetchGpsDataFromBe(String userId) async {
  try {
    print("[HomeAPI] Fetching GPS data for userId=$userId");

    final token = await SecureStorageManager.getToken();
    if (token == null) throw Exception("Token không tồn tại");

    final uri = Uri.parse('${baseUrl}/gps/$userId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final gpsData = jsonResponse['data'];
      print("[HomeAPI] Fetched GPS data: $gpsData");
      return gpsData;
    } else {
      throw Exception('Failed to fetch GPS data: ${response.statusCode}');
    }
  } catch (e) {
    print("[HomeAPI] Error fetching GPS data: $e");
    throw Exception('Error fetching GPS data: $e');
  }
}
