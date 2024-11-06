//appBar
import 'package:flutter/material.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../utils/colors.dart';

AppBar buildTransparentAppbar({required BuildContext context, String text = ""}) {
  return AppBar(
    backgroundColor: Colors.transparent, // Làm cho AppBar trong suốt
    elevation: 0, // Bỏ đổ bóng của AppBar
    centerTitle: true,
    title: text16Normal(
      text: text,
      color: AppColors.secondary,
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
      onPressed: () {
        // Quay lại trang trước
        Navigator.pop(context);
      },
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.favorite_border, color: AppColors.secondary),
        onPressed: () {
          // Xử lý khi nhấn vào nút yêu thích
        },
      ),
    ],
  );
}
