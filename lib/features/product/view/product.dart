import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/product/view/widgets/product_widgets.dart';
import '../../../common/utils/colors.dart';
import '../provider/product_category_notifier.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy danh mục hiện tại từ Notifier
    final selectedCategory = ref.watch(productCategoryProvider);
    // Lấy số trang hiện tại
    final currentPage = ref.watch(productPageProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text28Bold(
                        text: "Khám Phá", color: AppColors.secondary),
                    Icon(
                      Icons.notifications, // Biểu tượng quả chuông
                      color: AppColors.secondary,
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
              // Thanh tìm kiếm
              searchBar(),
              // Bộ lọc danh mục sản phẩm
              categoryFilter(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  ref.read(productCategoryProvider.notifier).updateCategory(category);
                  // Khi danh mục thay đổi, reset về trang đầu tiên
                  ref.read(productPageProvider.notifier).setPage(0);
                },
              ),
              // Hiển thị danh mục được chọn
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  selectedCategory,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Danh sách sản phẩm được lọc và phân trang
              productList(
                currentPage: currentPage,
                selectedCategory: selectedCategory,
                onPageChange: (newPage) {
                  ref.read(productPageProvider.notifier).setPage(newPage);
                },
              ),
              SizedBox(height: 20.h)
            ],
          ),
        ),
      ),
    );
  }
}
