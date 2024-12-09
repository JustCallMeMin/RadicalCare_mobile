import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInputField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final bool obscureText;

  const ProfileInputField({
    Key? key,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
