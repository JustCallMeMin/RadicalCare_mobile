import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/images.dart';

import '../../../../../common/routes/app_routes_name.dart';
import '../../../../../common/utils/colors.dart';
import '../../../../../common/widgets/app_textfieds.dart';
import '../../../../../common/widgets/button_widgets.dart';
import '../../../../../common/widgets/text_widgets.dart';
import '../../../../search/view/search.dart';
import '../../../booking/provider/booking_notifier.dart';
import '../../provider/home_notifier.dart';

Widget headerSection(
    BuildContext context, {
      required String imagePath,
      required String? fullName,
      required String? location, // Thêm vị trí GPS
    }) {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  return ClipPath(
    clipper: BottomCurveClipper(),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5), // Overlay màu đen
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên và Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fullName ?? "Tên người dùng",
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h), // Khoảng cách giữa tên và địa chỉ

              // Vị trí GPS
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                  SizedBox(width: 5.w),
                  text16Normal(
                    text: location ?? "Đang tải vị trí...",
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 20.h), // Khoảng cách giữa địa chỉ và thanh tìm kiếm

              // Thanh tìm kiếm
              appSearchBar(
                context: context,
                hintText: "Tìm và đặt dịch vụ tốt nhất",
                searchController: searchController,
                focusNode: focusNode,
                onSearch: (value) {
                  if (value.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(keyword: value),
                      ),
                    );
                  }
                },
                onClearSearch: () {
                  print("Search bar cleared");
                },
                onVoiceSearchTap: () {
                  print("Microphone tapped");
                },
              ),
            ],
          ),
        ),
      ),
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
  final motorServicesAsync = ref.watch(motorServicesProvider);

  return motorServicesAsync.when(
    data: (services) {
      // Gắn log để kiểm tra dữ liệu nhận được từ provider
      // print("Fetched services in servicePageView: $services");

      return Column(
        children: [
          SizedBox(
            height: 360.h,
            child: PageView.builder(
              itemCount: services.length,
              controller: PageController(viewportFraction: 0.85),
              onPageChanged: (value) {
                // Gắn log kiểm tra chỉ số trang hiện tại
                print("Page changed to index: $value");
                ref.read(homePageIndexProvider.notifier).changeIndex(value); // Cập nhật chỉ số khi trang thay đổi
              },
              itemBuilder: (context, index) {
                final service = services[index];

                // Gắn log kiểm tra service tại mỗi index
                print("Service at index $index: $service");

                return _serviceCard(
                  imagePath: service['imagePath'] ?? AppImages.service1, // Đường dẫn hình ảnh từ backend
                  serviceName: service['serviceName'] ?? "Unknown Service", // Tên dịch vụ từ backend
                  onTap: () {
                    // Gắn log khi người dùng bấm vào service card
                    print("Tapped on service: ${service['serviceName']}");

                    Navigator.of(context).pushNamed(
                      AppRoutesNames.BOOKING,
                      arguments: {
                        'serviceName': service['serviceName'] ?? "Unknown Service",
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      );
    },
    loading: () {
      print("Services are loading...");
      return const Center(child: CircularProgressIndicator());
    },
    error: (error, stack) {
      // Gắn log để kiểm tra lỗi nếu có
      print("Error fetching services: $error");
      return Center(
        child: Text("Failed to load services: $error"),
      );
    },
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
                  image: AssetImage(imagePath), // Hình ảnh từ backend hoặc mặc định
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
