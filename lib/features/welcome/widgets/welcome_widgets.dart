import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radicalcare/common/routes/app_routes_name.dart';
import 'package:radicalcare/common/widgets/app_shadows_widgets.dart';

import '../../../common/widgets/text_widgets.dart';

Widget appOnboardingPage(PageController controller, BuildContext context,
    {String imagePath = "",
    String title = "",
    String subTitle = "",
    int index = 0
    }) {
  return Column(
    children: [
      Image.asset(imagePath),
      Container(
          margin: EdgeInsets.only(top: 15), child: text24Normal(text: title)),
      Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.only(left: 30, right: 30),
        child: text16Normal(text: subTitle),
      ),
      _nextButton(index, controller, context)
    ],
  );
}

Widget _nextButton(int index, PageController controller, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (index < 3) {
        controller.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      } else {
        Navigator.pushNamed(context, AppRoutesNames.SIGN_UP);
        // Navigator.push(
        //   context,MaterialPageRoute(builder: (BuildContext context)=>const SignIn(),),
        // );
    }
    },
    child: Container(
      width: 325,
      height: 50,
      margin: EdgeInsets.only(top: 100, left: 25, right: 25),
      decoration: appBoxShadow(),
      child: Center(
          child: text16Normal(
              text: index == 3 ? "Bắt đầu" : "Tiếp tục", color: Colors.white)),
    ),
  );
}
