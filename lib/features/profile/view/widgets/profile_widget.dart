// Widget cho từng mục
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/colors.dart';


Widget profileOption({
  required IconData icon,
  required String title,
  required Function() onTap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => onTap(),
      horizontalTitleGap: 10.w,
    ),
  );
}