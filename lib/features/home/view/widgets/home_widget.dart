import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/images.dart';

import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/app_textfieds.dart';
import '../../../../common/widgets/button_widgets.dart';
import '../../../../common/widgets/text_widgets.dart';
import '../../provider/home_notifier.dart';

Widget headerSection({String imagePath = ""}) {
  return ClipPath(
    clipper: BottomCurveClipper(),
    child: Stack(
      children: [
        // Ảnh nền của header
        Container(
          height: 300.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text28Normal(
                          text: "Nguyễn Văn Tèo Em", color: Colors.white),
                      // Icon(
                      //   Icons.menu,
                      //   color: Colors.white,
                      //   size: 24.sp,
                      // ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 5.w),
                      text16Normal(text: "1234 Lò Lu", color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Thêm search bar ở dưới cùng
        Positioned(
          bottom: 110.h,
          left: 25.w,
          right: 25.w,
            child: appSearchBar(
              hintText: "Tìm và đặt dịch vụ tốt nhất",
              onSearch: (value) {
                // Xử lý khi người dùng nhập nội dung tìm kiếm
                print("Người dùng tìm: $value");
              },
              onVoiceSearchTap: () {
                // Xử lý khi người dùng nhấn vào biểu tượng microphone
                print("Microphone tapped");
              },
            ),
        ),
      ],
    ),
  );
}

Widget topCategories() {
  return Padding(
    padding: EdgeInsets.only(left: 0.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          height: 100.h, // Chiều cao của các thẻ danh mục
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25.w), // Đảm bảo tràn đều hai bên khi kéo
            scrollDirection: Axis.horizontal,
            children: [
              _categoryCard(
                imagePath: AppImages.service1,
                categoryName: "Bảo dưỡng",
              ),
              _categoryCard(
                imagePath: AppImages.service2,
                categoryName: "Dầu nhớt",
              ),
              _categoryCard(
                imagePath: AppImages.service3,
                categoryName: "Thay lốp",
              ),
              _categoryCard(
                imagePath: AppImages.service2,
                categoryName: "Sửa phanh",
              ),
              _categoryCard(
                imagePath: AppImages.service2,
                categoryName: "Rửa xe",
              ),
              _categoryCard(
                imagePath: AppImages.service3,
                categoryName: "Vệ sinh",
              ),
              _categoryCard(
                imagePath: AppImages.service2,
                categoryName: "Kiểm tra",
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


// Widget tạo các thẻ danh mục
Widget _categoryCard({
  required String imagePath,
  required String categoryName,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 10.w), // Khoảng cách giữa các thẻ
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Bo tròn các góc
          child: Image.asset(
            imagePath,
            height: 70.h,
            width: 70.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5.h),
        text14Normal(text: categoryName),
      ],
    ),
  );
}

// PageView với Riverpod để theo dõi trạng thái chỉ số
Widget servicePageView(BuildContext context, WidgetRef ref) {
  ref.watch(homePageIndexProvider);
  PageController _pageController = PageController(viewportFraction: 0.85); // Điều chỉnh tràn viền bên phải

  return Column(
    children: [
      SizedBox(
        height: 360.h,
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              ref.read(homePageIndexProvider.notifier).changeIndex(value); // Cập nhật chỉ số khi trang thay đổi
            },
            children: [
              _serviceCard(
                imagePath: AppImages.service1,
                serviceName: 'Độ Xe Theo Yêu Cầu',
                onTap: () => print('Hair Cutting tapped'),
              ),
              _serviceCard(
                imagePath: AppImages.service2,
                serviceName: 'Thay Thế Phụ Tùng Chính Hãng',
                onTap: () => print('Massage tapped'),
              ),
              _serviceCard(
                imagePath: AppImages.service3,
                serviceName: 'Bảo Dưỡng Định Kỳ',
                onTap: () => print('Hair Color tapped'),
              ),
            ],
          ),
      ),
      SizedBox(height: 20.h),
    ],
  );
}

Widget _serviceCard({
  required String imagePath,
  required String serviceName,
  required Function() onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 10.w), // Điều chỉnh khoảng cách giữa các thẻ
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            // Hình ảnh nền
            Container(
              height: 360.h, // Đặt chiều cao cụ thể cho thẻ
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Nội dung text và nút
            Positioned(
              bottom: 10.h, // Đặt nội dung ở dưới cùng
              left: 16.w,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text18Bold(text: serviceName, color: AppColors.primaryBg), // Hiển thị tên dịch vụ
                  SizedBox(height: 10.h),
                  appButton(
                    buttonName: "ĐẶT LỊCH NGAY",
                    buttonColor: AppColors.primary, // Màu nền trắng cho nút
                    buttonTextColor: AppColors.primaryBg, // Màu chữ
                    func: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
// CustomClipper để tạo đường cong dưới cùng của hình ảnh
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
