import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/home/view/widgets/homepage_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // Tiêu đề chính
            homepageTitle(text: "Discover"),
            SizedBox(height: 20.h),
            // Thanh tìm kiếm
            searchBar(),
            SizedBox(height: 20.h),
            // Danh mục sản phẩm
            categorySelector(),
            SizedBox(height: 20.h),
            // Lưới sản phẩm
            productGrid(),
            SizedBox(height: 20.h),
            // Lời mời gọi hành động
            callToAction(),
            SizedBox(height: 20.h),
            // Các ưu đãi và thông tin thêm
            additionalInfoSection(),
          ],
        ),
      ),
    );
  }
}
