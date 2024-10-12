//appBar
import 'package:flutter/material.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../utils/colors.dart';

AppBar buildAppbar({String text=""}) {
  return AppBar(
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Container(
        height: 1,
        color: Colors.grey.withOpacity(0.3),
      ),
    ),
    centerTitle: true,
    title: text16Normal(text: text, color: AppColors.secondary),
  );
}