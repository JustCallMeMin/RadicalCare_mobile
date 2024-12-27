import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/chat_notifier.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String user1;
  final String user2;

  const ChatScreen({
    super.key,
    required this.user1,
    required this.user2,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gọi fetchChatHistory sau khi khởi tạo widget
      ref.read(chatNotifierProvider.notifier).fetchChatHistory(widget.user1, widget.user2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final chatNotifier = ref.read(chatNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với CSKH'),
      ),
      body: Column(
        children: [
          if (chatState.isLoading)
            const Center(child: CircularProgressIndicator()),
          if (chatState.error != null)
            Center(
              child: Text(
                'Error: ${chatState.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (chatState.messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  return ListTile(
                    title: Text('${message['senderId']}: ${message['content']}'),
                    subtitle: Text(message['timestamp']),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () async {
                    // Gửi tin nhắn
                    await chatNotifier.sendMessage(
                      senderId: widget.user1,
                      recipientId: widget.user2,
                      content: 'Tin nhắn mẫu',
                    );
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
