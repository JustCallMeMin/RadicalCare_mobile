import 'package:flutter/material.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/home/view/home.dart';

Widget bottomNavigationWidget({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: onTap,
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppColors.primaryBg,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.unchecked,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    items: bottomTabs,
  );
}

// Danh sách các BottomNavigationBarItem được sử dụng trong widget.
var bottomTabs = <BottomNavigationBarItem>[
  const BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home),
    label: "Trang chủ",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today_outlined),
    activeIcon: Icon(Icons.calendar_today),
    label: "Đặt lịch",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.build_outlined),
    activeIcon: Icon(Icons.build),
    label: "Dịch vụ",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.shopping_cart_outlined),
    activeIcon: Icon(Icons.shopping_cart),
    label: "Giỏ hàng",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    activeIcon: Icon(Icons.person),
    label: "Tài khoản",
  ),
];

// Hàm _bottomContainer để tạo icon cho từng item.
Widget _bottomContainer({String? imagePath, Color? color}) {
  return Container(
    width: 24.0,
    height: 24.0,
    decoration: BoxDecoration(
      color: color ?? Colors.transparent,
    ),
    child: imagePath != null
        ? Image.asset(
      imagePath,
      fit: BoxFit.cover,
    )
        : const Icon(Icons.home),
  );
}

// Hàm appScreens để trả về các màn hình tương ứng với từng chỉ số.
Widget appScreens({int index = 0}) {
  List<Widget> screens = [
    const HomePage(),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('Services Screen')),
    const Center(child: Text('Shopping Cart Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  return screens[index];
}
