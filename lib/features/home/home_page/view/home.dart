import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/home/home_page/view/widgets/home_widget.dart';
import '../../../../common/utils/colors.dart';
import '../../../../common/utils/images.dart';
import '../provider/home_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    print("[HomePage] Initializing HomePage");

    // Tải dữ liệu lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homePageIndexProvider.notifier).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(homePageIndexProvider);
    final notifier = ref.watch(homePageIndexProvider.notifier);
    final fullName = notifier.fullName;
    final location = notifier.location;

    print("[HomePage] Building UI with fullName: $fullName, location: $location");

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              width: double.infinity,
              child: headerSection(
                context,
                imagePath: AppImages.homeBanner,
                fullName: fullName ?? "Đang tải...",
                location: location ?? "Đang tải...",
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      text22Bold(text: "Danh mục dịch vụ"),
                      GestureDetector(
                        onTap: () => print("[HomePage] Show all tapped"),
                        child: Row(
                          children: [
                            text16Normal(
                                text: "Xem thêm", color: AppColors.primary),
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
                topCategories(ref),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: text22Bold(text: "Đề xuất"),
                ),
                SizedBox(height: 10.h),
                servicePageView(context, ref),
                SizedBox(height: 80.h)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
