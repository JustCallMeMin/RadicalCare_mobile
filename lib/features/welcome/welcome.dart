import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/features/welcome/widgets/welcome_widgets.dart';

import '../../common/utils/images.dart';
import 'notifier/welcome_notifier.dart';

class Welcome extends ConsumerWidget {
  Welcome({Key? key}) : super(key: key);
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexDotProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Stack(alignment: Alignment.topCenter, children: [
                PageView(
                  onPageChanged: (value) {
                    ref.read(indexDotProvider.notifier).changeIndex(value);
                  },
                  controller: _controller,
                  //scroll behavior
                  scrollDirection: Axis.horizontal,
                  children: [
                    //first page
                    appOnboardingPage(_controller,context,
                        imagePath: AppImages.welcome1,
                        title: "Kết nối với khách hàng",
                        subTitle:
                            "Luôn giữ liên lạc với khách hàng qua nền tảng chăm sóc chuyên nghiệp",
                        index: 1),
                    //second page
                    appOnboardingPage(_controller,context,
                        imagePath: AppImages.welcome2,
                        title: "Quản lý lịch bảo dưỡng",
                        subTitle:
                            "Đặt lịch, nhận nhắc nhở và theo dõi bảo dưỡng xe ngay trên ứng dụng",
                        index: 2),
                    //third page
                    appOnboardingPage(_controller,context,
                        imagePath: AppImages.welcome3,
                        title: "Hỗ trợ khách hàng mọi lúc",
                        subTitle:
                            "Liên hệ ngay để nhận tư vấn, hỗ trợ và giải đáp thắc mắc về xe máy của bạn.",
                        index: 3,)
                  ],
                ),
                //indicators
                Positioned(
                  bottom: 75.h,
                  child: DotsIndicator(
                    position: index,
                    dotsCount: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    decorator: DotsDecorator(
                        size: const Size.square(9.0),
                        activeColor: AppColors.primary,
                        activeSize: const Size(24.0, 8.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
              ]),
            )),
      ),
    );
  }
}
