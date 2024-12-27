import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';
import 'api_config.dart';

class ChatApi {
  /// Gửi tin nhắn
  static Future<void> sendMessage({
    required String senderId,
    required String recipientId,
    String? content,
    List<String>? imagePaths,
  }) async {
    final url = Uri.parse('$baseUrl/chat/send');

    // Chuẩn bị dữ liệu cho multipart request
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${await SecureStorageManager.getToken()}'
      ..fields['senderId'] = senderId
      ..fields['recipientId'] = recipientId;

    if (content != null) {
      request.fields['content'] = content;
    }

    if (imagePaths != null && imagePaths.isNotEmpty) {
      for (final imagePath in imagePaths) {
        request.files.add(await http.MultipartFile.fromPath('images', imagePath));
      }
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to send message: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Lấy lịch sử chat giữa 2 người dùng
  static Future<List<Map<String, dynamic>>> fetchChatHistory({
    required String user1,
    required String user2,
  }) async {
    final url = Uri.parse('$baseUrl/chat/history/$user1/$user2');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch chat history: ${response.reasonPhrase} (${response.statusCode})');
    }
  }

  /// Xóa lịch sử chat (nếu cần thêm tính năng này)
  static Future<void> deleteChatHistory(String chatId) async {
    final url = Uri.parse('$baseUrl/chat/$chatId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageManager.getToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete chat history: ${response.reasonPhrase} (${response.statusCode})');
    }
  }
}
