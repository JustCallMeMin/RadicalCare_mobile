import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final Color buttonColor; // Màu nền của nút
  final Color textColor; // Màu văn bản của nút

  const SubmitButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    this.buttonColor = Colors.blueAccent, // Mặc định là màu xanh
    this.textColor = Colors.white, // Mặc định là màu trắng
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          backgroundColor: buttonColor, // Màu nền tùy chỉnh
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          "Cập nhật thông tin",
          style: TextStyle(fontSize: 18.sp, color: textColor), // Màu văn bản tùy chỉnh
        ),
      ),
    );
  }
}
