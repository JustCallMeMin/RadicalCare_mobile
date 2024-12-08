import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../utils/secure_storage.dart';
import 'api_config.dart'; // Token retrieval utility

/// Lấy thông tin người dùng hiện tại
Future<User> fetchUserInfo() async {
  try {
    // Lấy token từ Secure Storage
    final token = await SecureStorageManager.getToken();
    if (token == null) throw Exception("Token không tồn tại");

    // Tạo URI để gọi API
    final uri = Uri.parse('${ApiConfig.baseUrl}/auth/fetch-user'); // Đảm bảo endpoint đúng
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(jsonResponse); // Mapping JSON về đối tượng User
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized - Token không hợp lệ hoặc đã hết hạn.");
    } else {
      throw Exception('Failed to fetch user info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching user info: $e');
  }
}