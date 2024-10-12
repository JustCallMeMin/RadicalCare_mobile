import 'package:flutter/material.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/application/view/widgets/application_widget.dart';

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<Application> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: appScreens(index: _currentIndex),
      bottomNavigationBar: bottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
