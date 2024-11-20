import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = "http://192.168.1.33:8080/api/v1/auth";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Đăng nhập và lưu token vào Secure Storage
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Kiểm tra token trước khi lưu
        if (token == null || token.isEmpty) {
          return {
            "success": false,
            "message": "Failed to retrieve token.",
          };
        }

        // Lưu token vào Secure Storage
        await _secureStorage.write(key: 'auth_token', value: token);
        print("Token saved successfully: $token");

        return {
          "success": true,
          "token": token,
        };
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? 'Failed to sign in',
        };
      }
    } catch (error) {
      print("Error during sign in: $error");
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }

  // Đăng ký người dùng
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String address,
    required String doB,
  }) async {
    final url = Uri.parse("$_baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": fullName,
          "username": userName,
          "email": email,
          "password": password,
          "address": address,
          "doB": doB,
        }),
      );

      if (response.statusCode == 201) {
        return {
          "success": true,
          "message": "User registered successfully",
        };
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? 'Failed to register',
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }

  // Kiểm tra xem người dùng đã đăng nhập hay chưa bằng token
  Future<bool> isLoggedIn() async {
    String? token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  // Đăng xuất người dùng và xóa token
  Future<void> logOut() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Lấy token từ SecureStorage
  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'auth_token');
    print("Retrieved token: $token");
    return token;
  }
}
