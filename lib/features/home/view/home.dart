import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/home/view/widgets/home_widget.dart';

import '../../../common/utils/colors.dart';
import '../../../common/utils/images.dart';
import '../provider/home_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(homePageIndexProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần header
            SizedBox(
              height: 300.h,
              width: double.infinity,
              child: headerSection(imagePath: AppImages.homeBanner),
            ),
             Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần tiêu đề và nút "Xem thêm"
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text22Bold(text: "Danh mục dịch vụ"),
                        GestureDetector(
                          onTap: () => print("Show all tapped"),
                          child: Row(
                            children: [
                              text16Normal(text: "Xem thêm", color: AppColors.primary),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14.sp,
                                color: AppColors.primary,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Phần topCategories sẽ được canh lề đều ở cả hai bên
                  topCategories(),
                  SizedBox(height: 10.h),
                  // Phần tiêu đề "Đề xuất"
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: text22Bold(text: "Đề xuất"),
                  ),
                  SizedBox(height: 10.h),
                  servicePageView(context, ref),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
