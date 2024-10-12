import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

BoxDecoration appButtonDecoration({
  required Color buttonColor,
  bool isOutlined = false,
}) {
  return BoxDecoration(
    color: isOutlined ? buttonColor : Colors.transparent,
    borderRadius: BorderRadius.circular(8), // Sử dụng cùng một BorderRadius
    border: isOutlined ? Border.all(color: AppColors.secondary) : null,
    boxShadow: isOutlined
        ? []
        : [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );
}

Widget appButton({
  double height = 50,
  double width = 325,
  String buttonName = "",
  Color buttonTextColor = AppColors.primaryBg,
  Color buttonColor = AppColors.primary,
  bool isLogin = false,
  bool isOutlined = true,
  BuildContext? context,
  void Function()? func,
}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: width.w,
      height: height.h,
      decoration: appButtonDecoration(
        buttonColor: isLogin ? AppColors.primary :  buttonColor,
        isOutlined: isOutlined,
      ),
      child: Center(
        child: text16Normal(
          text: buttonName,
          color: isOutlined ? buttonTextColor : AppColors.secondary,
        ),
      ),
    ),
  );
}

Widget appThirdPartyButton({
  required String buttonName,
  required String iconPath, // Đường dẫn đến biểu tượng
  Color buttonColor = AppColors.primaryBg,
  Color textColor = AppColors.secondary,
  double height = 50,
  double width = 325,
  bool isOutlined = true,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width.w,
      height: height.h,
      decoration: appButtonDecoration(
        buttonColor: buttonColor,
        isOutlined: isOutlined,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Biểu tượng bên trái
          Image.asset(
            iconPath,
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 10.w),
          // Văn bản bên cạnh biểu tượng
          text16Normal(
            text: buttonName,
            color: textColor,
          ),
        ],
      ),
    ),
  );
}
