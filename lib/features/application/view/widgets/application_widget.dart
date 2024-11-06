import 'package:flutter/material.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/favorite/view/favorite.dart';
import 'package:radicalcare/features/home/view/home.dart';
import 'package:radicalcare/features/product/view/product.dart';

Widget bottomNavigationWidget({
  required int currentIndex,
  required Function(int) onTap,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    margin: const EdgeInsets.all(16.0), // Tạo khoảng cách giữa navigation và cạnh màn hình
    decoration: BoxDecoration(
      color: AppColors.secondary, // Nền màu đen tương tự như hình mẫu
      borderRadius: BorderRadius.circular(40.0), // Bo tròn để tạo hình con nhộng
      boxShadow: [
        BoxShadow(
          color: AppColors.secondary.withOpacity(0.2), // Màu bóng mờ
          spreadRadius: 5,
          blurRadius: 10,
          offset: Offset(0, 3), // Vị trí bóng đổ
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 0,
            currentIndex: currentIndex,
            onTap: onTap
        ),
        _buildNavItem(
            icon: Icons.shopping_bag_outlined,
            activeIcon: Icons.shopping_bag,
            index: 1,
            currentIndex: currentIndex,
            onTap: onTap
        ),
        _buildNavItem(
            icon: Icons.favorite_outline,
            activeIcon: Icons.favorite,
            index: 2,
            currentIndex: currentIndex,
            onTap: onTap
        ),
        _buildNavItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            index: 3,
            currentIndex: currentIndex,
            onTap: onTap
        ),
        _buildNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            index: 4,
            currentIndex: currentIndex,
            onTap: onTap
        ),
      ],
    ),
  );
}

Widget _buildNavItem({
  required IconData icon,
  required IconData activeIcon,
  required int index,
  required int currentIndex,
  required Function(int) onTap,
}) {
  final bool isSelected = currentIndex == index;

  return GestureDetector(
    onTap: () => onTap(index),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent, // Nền hình tròn khi được chọn
            shape: BoxShape.circle, // Định dạng tròn
          ),
          child: Icon(
            isSelected ? activeIcon : icon, // Biểu tượng thay đổi khi được chọn
            color: isSelected ? AppColors.primary : Colors.grey, // Màu khi được chọn là nâu, nếu không thì xám
            size: 24.0, // Điều chỉnh kích thước icon
          ),
        ),
      ],
    ),
  );
}

// Hàm appScreens để trả về các màn hình tương ứng với từng chỉ số.
Widget appScreens({int index = 0}) {
  List<Widget> screens = [
    const HomePage(),
    const ProductPage(),
    const FavoriteScreen(),
    const Center(child: Text('Giỏ hàng')),
    const Center(child: Text('Tài khoản')),
  ];

  return screens[index];
}
