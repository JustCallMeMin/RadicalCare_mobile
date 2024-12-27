import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/api/chat_api.dart';

class ChatState {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    required this.isLoading,
    this.error,
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState(messages: [], isLoading: false));

  /// Lấy lịch sử chat giữa hai người dùng
  Future<void> fetchChatHistory(String user1, String user2) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final chatHistory = await ChatApi.fetchChatHistory(user1: user1, user2: user2);
      state = state.copyWith(messages: chatHistory, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Gửi tin nhắn mới
  Future<void> sendMessage({
    required String senderId,
    required String recipientId,
    String? content,
    List<String>? imagePaths,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ChatApi.sendMessage(
        senderId: senderId,
        recipientId: recipientId,
        content: content,
        imagePaths: imagePaths,
      );

      // Thêm tin nhắn mới vào danh sách
      final newMessage = {
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content ?? '',
        'timestamp': DateTime.now().toIso8601String(),
        'uploadedImages': imagePaths ?? [],
      };

      state = state.copyWith(
        messages: [...state.messages, newMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final chatNotifierProvider =
StateNotifierProvider<ChatNotifier, ChatState>((ref) => ChatNotifier());
