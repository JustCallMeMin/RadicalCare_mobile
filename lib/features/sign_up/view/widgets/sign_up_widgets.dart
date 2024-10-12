import 'package:flutter/material.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../../../../common/utils/colors.dart'; // Đường dẫn của text16Normal và textUnderline

Widget loginPrompt({
  required BuildContext context,
  String text = "Bạn đã có tài khoản? ",
  String linkText = "Đăng nhập",
  Color textColor = AppColors.content,
  Color linkColor = AppColors.secondary,
  void Function()? func,
}) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Văn bản bình thường
        text16Normal(
          text: text,
          color: textColor,
        ),
        // Phần có thể nhấn được sử dụng trực tiếp từ textUnderline
        textUnderline(
          text: linkText,
          color: linkColor,
          func: func,
        ),
      ],
    ),
  );
}

