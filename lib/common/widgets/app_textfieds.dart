import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../utils/colors.dart';
import '../utils/images.dart';
import 'image_widgets.dart';

Widget appTextField({
  String text = "",
  String iconVisible = AppImages.eyeClose,
  String iconHidden = AppImages.eye,
  String iconName = AppImages.eyeClose,

  String hintText = "",
  bool isPasswordField = true,
  bool obscureText = false,
  bool isDirty = false,
  Color color = AppColors.content,
  TextInputType keyboardType = TextInputType.text,
  void Function(String value)? func,
  void Function()? onIconTap,
  String? Function(String?)? validator,
}) {
  return Container(
    padding: EdgeInsets.only(left: 25.w, right: 25.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text14Normal(text: text, color: color),
        SizedBox(height: 5.h),
        TextFormField(
          onChanged: (value) {
            func?.call(value);
          },
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.content),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5.w,
              ),
            ),
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            // Sử dụng suffixIcon để giữ cố định biểu tượng mắt
            suffixIcon: isPasswordField
                ? GestureDetector(
              onTap: onIconTap,
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: appImage(
                  imagePath: obscureText ? iconVisible : iconHidden,
                ),
              ),
            )
                : null,
          ),
          maxLines: 1,
          autocorrect: false,
          obscureText: isPasswordField ? obscureText : false,
          validator: validator,
        ),
      ],
    ),
  );
}

Widget appSearchBar({
  required String hintText,
  required Function(String value) onSearch,
  required VoidCallback onVoiceSearchTap,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    height: 50.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,  // Thêm dòng này để Row không cố mở rộng hết không gian
      children: [
        const Icon(Icons.search, color: Colors.grey),
        SizedBox(width: 10.w),
        Flexible(  // Thay vì sử dụng Expanded, dùng Flexible để kiểm soát kích thước linh hoạt
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            onChanged: onSearch,
          ),
        ),
        const Icon(Icons.mic, color: Colors.grey),
      ],
    ),
  );
}

