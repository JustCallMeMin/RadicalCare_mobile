import 'package:flutter/material.dart';
import 'package:radicalcare/common/utils/images.dart';

import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/text_widgets.dart';

Widget registerPrompt({
  required BuildContext context,
  String text = "Bạn chưa có tài khoản? ",
  String linkText = "Đăng ký",
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

//icons thirdParty login
Widget _loginButton(String imagePath) {
  return GestureDetector(
    child: Container(
      width: 40,
      height: 40,
      child: Image.asset(imagePath),
    ),
  );
}
