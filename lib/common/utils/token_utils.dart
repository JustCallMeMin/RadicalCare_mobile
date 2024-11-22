import 'dart:convert';

class TokenUtils {
  // Giải mã JWT và trích xuất userId
  static String? getUserIdFromToken(String token) {
    try {
      // Tách payload
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT');
      }

      // Decode payload
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);

      // Trích xuất userId
      return payloadMap['userId'] as String?;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }
}
