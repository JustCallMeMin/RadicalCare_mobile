import 'package:flutter/material.dart';

class DraggableChatBubble extends StatefulWidget {
  final VoidCallback onTap;

  const DraggableChatBubble({super.key, required this.onTap});

  @override
  _DraggableChatBubbleState createState() => _DraggableChatBubbleState();
}

class _DraggableChatBubbleState extends State<DraggableChatBubble> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    // Vị trí mặc định của bong bóng chat
    position = const Offset(20, 600);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                // Cập nhật vị trí dựa trên thao tác kéo thả
                position += details.delta;
              });
            },
            onTap: widget.onTap,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.chat, color: Colors.white),
              onPressed: widget.onTap,
            ),
          ),
        ),
      ],
    );
  }
}
