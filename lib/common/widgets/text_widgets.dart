import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

Widget text24Normal({String text = "", Color color = AppColors.secondary}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
          TextStyle(color: color, fontSize: 24.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text22Normal({String text = "", Color color = AppColors.secondary}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 22.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text22Bold({String text = "", Color color = AppColors.secondary}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 22.sp, fontWeight: FontWeight.bold),
    ),
  );
}
Widget text28Normal({String text = "", Color color = AppColors.content}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 28.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text28Bold({String text = "", Color color = AppColors.content}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 28.sp, fontWeight: FontWeight.bold),
    ),
  );
}
Widget text16Normal({String text = "", Color color = AppColors.content}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
          TextStyle(color: color, fontSize: 16.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text16Bold({String text = "", Color color = AppColors.content}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 16.sp, fontWeight: FontWeight.bold),
    ),
  );
}
Widget text14Normal(
    {String text = "",
    Color color = AppColors.content,
    TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
      textStyle:
          TextStyle(color: color, fontSize: 14.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text18Normal(
    {String text = "",
      Color color = AppColors.content,
      TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 18.sp, fontWeight: FontWeight.normal),
    ),
  );
}
Widget text18Bold(
    {String text = "",
      Color color = AppColors.content,
      TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 18.sp, fontWeight: FontWeight.bold),
    ),
  );
}
Widget text12Normal(
    {String text = "",
      Color color = Colors.red,
      TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
      textStyle:
      TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.normal),
    ),
  );
}

Widget text32Bold(
    {String text = "",
    Color color = AppColors.secondary,
    TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
      textStyle:
          TextStyle(color: color, fontSize: 32.sp, fontWeight: FontWeight.bold),
    ),
  );
}

Widget textUnderline({String text = "", Color color = AppColors.secondary,void Function()? func,}) {
  return GestureDetector(
    onTap: func,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12.sp,
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: AppColors.secondary,
      ),
    ),
  );
}
