import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../utils/colors.dart';

Widget appDivider({
  String text = "Or",
  Color lineColor = AppColors.content,
  Color textColor = AppColors.content,
  double thickness = 1.0,
  double horizontalPadding = 8,
  double dividerPadding = 25, // Thêm tham số để điều chỉnh padding cạnh màn hình
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: dividerPadding.w), // Padding cạnh màn hình
    child: Row(
      children: [
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: thickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
          child: text14Normal(
            text: text,
            color: textColor,
          ),
        ),
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: thickness,
          ),
        ),
      ],
    ),
  );
}
