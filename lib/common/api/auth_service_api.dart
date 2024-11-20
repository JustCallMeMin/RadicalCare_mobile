import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = "http://192.168.1.33:8080/api/v1/auth";

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "token": data['token'],
        };
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ??
              'Failed to sign in',
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String address,
    required String doB,
  }) async {
    final url = Uri.parse("http://192.168.1.33:8080/api/v1/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
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
          "message": jsonDecode(response.body)['message'] ??
              'Failed to register',
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }
}
