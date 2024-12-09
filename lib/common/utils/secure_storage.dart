import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:radicalcare/common/model/vehicle.dart'; // Import model Vehicle

class SecureStorageManager {
  static const _storage = FlutterSecureStorage();

  // Key constants
  static const String tokenKey = 'authToken'; // Key lưu trữ token
  static const String favoriteKey = 'favoriteProducts'; // Key lưu sản phẩm yêu thích

  // Lưu dữ liệu (key-value)
  static Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Đọc dữ liệu (key-value)
  static Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  // Xóa dữ liệu (key-value)
  static Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // Xóa tất cả dữ liệu
  static Future<void> clearAllData() async {
    await _storage.deleteAll();
  }

  // Lưu token
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: tokenKey, value: token);
      print("SecureStorageManager: Token saved successfully - $token");
    } catch (e) {
      print("SecureStorageManager: Error saving token - $e");
    }
  }

  // Lấy token
  static Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: tokenKey);
      return token;
    } catch (e) {
      print("SecureStorageManager: Error retrieving token - $e");
      return null;
    }
  }

  // Xóa token
  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: tokenKey);
      print("SecureStorageManager: Token cleared successfully.");
    } catch (e) {
      print("SecureStorageManager: Error clearing token - $e");
    }
  }

  // Lưu danh sách sản phẩm yêu thích
  static Future<void> saveFavoriteProducts(List<Vehicle> favoriteProducts) async {
    try {
      String jsonData = jsonEncode(favoriteProducts.map((e) => e.toJson()).toList());
      await saveData(favoriteKey, jsonData);
      print("Favorite products saved successfully");
    } catch (e) {
      print("Error saving favorite products: $e");
    }
  }

  // Lấy danh sách sản phẩm yêu thích
  static Future<List<Vehicle>> getFavoriteProducts() async {
    try {
      String? jsonData = await readData(favoriteKey);
      if (jsonData == null) return [];
      List<dynamic> data = jsonDecode(jsonData);
      return data.map((e) => Vehicle.fromJson(e)).toList();
    } catch (e) {
      print("Error retrieving favorite products: $e");
      return [];
    }
  }

  // Giải mã JWT để lấy claim
  static String? _getClaimFromToken(String token, String claimKey) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT');
      }
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);
      return payloadMap[claimKey] as String?;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  // Lấy userId từ token đã lưu
  static Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;
    return _getClaimFromToken(token, 'userId');
  }

  // Lấy customerId từ token đã lưu
  static Future<String?> getCustomerId() async {
    final token = await getToken();
    if (token == null) return null;
    return _getClaimFromToken(token, 'customerId');
  }
}
