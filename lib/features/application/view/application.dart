import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/application/provider/application_notifier.dart';
import 'package:radicalcare/features/application/view/widgets/application_widget.dart';
import 'package:radicalcare/features/application/view/widgets/chat_bubble.dart';

import '../../chat/view/chat.dart';

class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomBarVisible = ref.watch(applicationNotifierProvider);
    final currentIndex = ref.watch(currentIndexNotifierProvider);

    // Người dùng hiện tại
    const user1 = 'currentUserId'; // Thay thế bằng logic lấy userId hiện tại
    const user2 = 'supportStaffId'; // Thay thế bằng ID của nhân viên CSKH

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryBg,
      body: Stack(
        children: [
          appScreens(index: currentIndex), // Hiển thị màn hình hiện tại
          DraggableChatBubble(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user1: user1, user2: user2),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: isBottomBarVisible
          ? bottomNavigationWidget(
        currentIndex: currentIndex,
        onTap: (int index) {
          ref
              .read(currentIndexNotifierProvider.notifier)
              .updateIndex(index);

          if (index == 3) {
            ref
                .read(applicationNotifierProvider.notifier)
                .hideBottomBar();
          } else {
            ref
                .read(applicationNotifierProvider.notifier)
                .showBottomBar();
          }
        },
      )
          : null,
    );
  }
}
