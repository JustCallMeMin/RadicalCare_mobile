import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Google Sign-In Configuration
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "362465558356-l0fao1a8m1ltcpnbjog9unl2mfqa6c20.apps.googleusercontent.com", // Android client ID
    serverClientId: "362465558356-mhl0lrv5hmsgb17q5rf5851h5hq72ecq.apps.googleusercontent.com", // Web client ID cho BE
    scopes: [
      'email',
      'profile',
      'openid',
    ],
    // forceCodeForRefreshToken: true, // Bắt buộc lấy auth code cho backend
  );

  // Sign In with Google
  Future<void> signInWithGoogle() async {
    try {
      print("=== Google Sign-In Started ===");

      // Đăng nhập với Google
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print("Google Sign-In canceled.");
        return;
      }

      // Lấy ID Token từ Google
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        print("Google ID Token is null.");
        return;
      }

      print("Google ID Token: $idToken");

      // Gửi ID Token lên BE
      final response = await http.post(
        Uri.parse("${baseUrl}/auth/oauth/google"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Lưu JWT và giải mã để lấy thông tin `userId` và `customerId`
        final String jwtToken = data['token'];
        await _secureStorage.write(key: 'auth_token', value: jwtToken);

        print("Received JWT Token: $jwtToken");

        // Giải mã JWT để lấy thông tin
        final decodedToken = _decodeJwt(jwtToken);
        final String? userId = decodedToken['userId'];
        final String? customerId = decodedToken['customerId'];

        if (userId != null && customerId != null) {
          await _secureStorage.write(key: 'user_id', value: userId);
          await _secureStorage.write(key: 'customer_id', value: customerId);
          print("User ID: $userId, Customer ID: $customerId");
        }

        print("Login with Google successfully completed.");
      } else {
        print("Backend Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }

  Future<Map<String, dynamic>?> sendIdTokenToBackend(String idToken) async {
    final url = Uri.parse("${baseUrl}/auth/oauth/google");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"idToken": idToken}), // Gửi ID Token lên server
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Backend Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error sending ID Token to Backend: $e");
    }
    return null;
  }

  // Send Authorization Code to Backend
  Future<Map<String, dynamic>?> sendAuthCodeToBackend(String authCode) async {
    final url = Uri.parse("${baseUrl}/auth/oauth/google");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"authCode": authCode}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Backend Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error sending Authorization Code to Backend: $e");
    }
    return null;
  }

  // Retrieve Token from SecureStorage
  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'auth_token');
    print("Retrieved token: $token");
    return token;
  }

  // Log Out and Clear Token
  Future<void> logOut() async {
    await _secureStorage.delete(key: 'auth_token');
    await _googleSignIn.signOut();
    print("Logged out successfully.");
  }

  /// Giải mã JWT để kiểm tra payload
  Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));

    return jsonDecode(decoded);
  }


  // Đăng nhập và lưu token vào Secure Storage
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse("${baseUrl}/auth/login");

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
    required String phoneNumber,
    required String doB,
  }) async {
    final url = Uri.parse("${baseUrl}/auth/register");

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
          "phoneNumber": phoneNumber,
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

  // Lấy token từ SecureStorage

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse("${baseUrl}/auth/update-profile");

    try {
      final token = await getToken();
      if (token == null) throw Exception("Token missing");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData), // Sử dụng profileData đã qua xử lý
      );

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Update failed"
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }
  // Lấy thông tin người dùng
  Future<Map<String, dynamic>> fetchUser() async {
    final url = Uri.parse("${baseUrl}/auth/fetch-user");

    try {
      final token = await getToken();
      if (token == null) throw Exception("Token is missing");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "username": data["username"],
          "email": data["email"],
        };
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Failed to fetch user"
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