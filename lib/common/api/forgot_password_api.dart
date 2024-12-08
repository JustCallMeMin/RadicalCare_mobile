import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart'; // Import ApiConfig

class ForgotPasswordApi {
  // Gửi email để đặt lại mật khẩu
  static Future<String?> sendForgotPasswordEmail(String email) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/forgot-password');
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
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/reset-password');

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
        final responseBody = jsonDecode(response.body);
        return responseBody['message'] ?? "Không thể đặt lại mật khẩu.";
      }
    } catch (e) {
      throw Exception("Đã xảy ra lỗi trong quá trình đặt lại mật khẩu: $e");
    }
  }
}