import 'dart:io';

final Map<String, String> serverIPs = {
  'mac': 'http://192.168.101.62:8080/api/v1',
  'pc': 'http://192.168.1.33:8080/api/v1',
};

class ApiConfig {
  static String? _baseUrl;

  static Future<void> detectServer() async {
    for (var entry in serverIPs.entries) {
      try {
        final result = await InternetAddress.lookup(
            entry.value.split('//')[1].split(':')[0]);
        if (result.isNotEmpty) {
          _baseUrl = entry.value;
          break;
        }
      } catch (e) {
        // Không kết nối được server này, tiếp tục kiểm tra server khác
      }
    }
    if (_baseUrl == null) {
      throw Exception('No available server detected.');
    }
  }

  static String get baseUrl {
    if (_baseUrl == null) {
      throw Exception(
          'Base URL is not initialized. Call detectServer() first.');
    }
    return _baseUrl!;
  }
}
