import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordApi {
  static const String baseUrl = 'http://192.168.2.14:8080/api/v1'; // URL của API backend

  // Gửi email để đặt lại mật khẩu
  static Future<String?> sendForgotPasswordEmail(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded', // Header đúng
        },
        body: {
          'email': email, // Gửi email đúng định dạng
        },
      );

      if (response.statusCode == 200) {
        return "Yêu cầu thành công. Kiểm tra email của bạn.";
      } else {
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? "Lỗi không xác định.";
      }
    } catch (e) {
      return "Lỗi kết nối tới server: $e";
    }
  }

  // Đặt lại mật khẩu với token
  static Future<String> resetPassword(String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');

    try {
      final response = await http.post(
        url,
        body: {
          'token': token,
          'newPassword': newPassword,
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['message'] ?? "Đặt lại mật khẩu thành công";
      } else {
        throw Exception("Không thể đặt lại mật khẩu: ${response.body}");
      }
    } catch (e) {
      throw Exception("Đã xảy ra lỗi trong quá trình đặt lại mật khẩu: $e");
    }
  }
}
