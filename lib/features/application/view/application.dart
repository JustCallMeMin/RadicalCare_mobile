import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/application/provider/application_notifier.dart';
import 'package:radicalcare/features/application/view/widgets/application_widget.dart';

class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBottomBarVisible = ref.watch(applicationNotifierProvider);
    final currentIndex = ref.watch(currentIndexNotifierProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryBg,
      body: appScreens(index: currentIndex),
      bottomNavigationBar: isBottomBarVisible
          ? bottomNavigationWidget(
        currentIndex: currentIndex,
        onTap: (int index) {
          ref.read(currentIndexNotifierProvider.notifier).updateIndex(index);

          // Hiển thị/ẩn BottomNavigationBar dựa trên trang
          if (index == 3) {
            ref.read(applicationNotifierProvider.notifier).hideBottomBar();
          } else {
            ref.read(applicationNotifierProvider.notifier).showBottomBar();
          }
        },
      )
          : null,
    );
  }
}
