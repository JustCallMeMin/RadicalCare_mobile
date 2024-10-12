import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/images.dart';

Widget appImage(
    {String imagePath = "", double width = 16, double height = 16}) {
  return Image.asset(
    imagePath.isEmpty ? AppImages.user : imagePath,
    width: width.w,
    height: height.h,
  );
}
