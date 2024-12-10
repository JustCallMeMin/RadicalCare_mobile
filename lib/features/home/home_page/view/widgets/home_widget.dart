import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/image_widgets.dart';

import '../../../../../common/model/appointment_detail.dart';
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

Widget topCategories(WidgetRef ref) {
  final motorServicesAsync = ref.watch(motorServicesProvider);

  return Padding(
    padding: EdgeInsets.only(left: 0.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        SizedBox(
          height: 120.h, // Chiều cao của các thẻ danh mục
          child: motorServicesAsync.when(
            data: (services) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _categoryCard(
                    imagePath: service['imagePath'] ?? AppImages.service1, // Đường dẫn hình ảnh
                    categoryName: service['serviceName'], // Tên danh mục
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
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
        SizedBox(
          width: 70.h, // Đặt chiều rộng cố định để kiểm soát text wrap
          child: Text(
            categoryName,
            textAlign: TextAlign.center, // Căn giữa
            style: TextStyle(
              fontSize: 14.sp,
              overflow: TextOverflow.ellipsis, // Thêm ... nếu quá dài
            ),
            maxLines: 2, // Cho phép xuống dòng tối đa 2 dòng
          ),
        ),
      ],
    ),
  );
}

// PageView với Riverpod để theo dõi trạng thái chỉ số
Widget servicePageView(BuildContext context, WidgetRef ref) {
  final motorServicesAsync = ref.watch(motorServicesProvider);

  return motorServicesAsync.when(
    data: (services) {
      return Column(
        children: [
          SizedBox(
            height: 360.h,
            child: PageView.builder(
              itemCount: services.length,
              controller: PageController(viewportFraction: 0.85),
              onPageChanged: (value) {
                ref.read(homePageIndexProvider.notifier).changeIndex(value);
              },
              itemBuilder: (context, index) {
                final service = services[index]; // Đây là Map<String, dynamic>

                return _serviceCard(
                  imagePath: AppImages.service1, // Hình ảnh mặc định
                  serviceName: service['serviceName'] ?? 'Unknown Service',
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutesNames.BOOKING,
                      arguments: {
                        'serviceName': service['serviceName'],
                        'cost': service['cost'] ?? 0.0,
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
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Center(
      child: Text("Failed to load services: $error"),
    ),
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
