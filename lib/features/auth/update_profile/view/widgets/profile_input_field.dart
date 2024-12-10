import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInputField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final bool obscureText;
  final String? Function(String?)? validator; // Thêm validator
  final Color borderColor;
  final Color labelColor;

  const ProfileInputField({
    Key? key,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    this.obscureText = false,
    this.validator,
    this.borderColor = Colors.grey,
    this.labelColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextFormField(
        key: ValueKey(label), // Bảo đảm widget tái tạo đúng khi state thay đổi
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: (value) {
          onChanged(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction, // Kiểm tra lỗi tự động
        validator: validator, // Truyền validator vào đây
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: labelColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }
}
