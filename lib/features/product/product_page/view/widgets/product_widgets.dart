import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import '../../../../../common/model/vehicle_model.dart';
import '../../../../../common/routes/app_routes_name.dart';
import '../../../../../common/widgets/app_textfieds.dart';
import '../../../../search/view/search.dart';
import '../../provider/product_notifier.dart';

Widget searchBar(
    BuildContext context,
    WidgetRef ref,
    TextEditingController searchController,
    ) {
  final FocusNode focusNode = FocusNode();

  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Row(
      children: [
        Expanded(
          child: appSearchBar(
            context: context,
            hintText: 'Tìm kiếm sản phẩm...',
            searchController: searchController,
            focusNode: focusNode, // Gắn FocusNode
            onSearch: (value) {
              if (value.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(keyword: value),
                ));
              }
            },
            onClearSearch: () {
              print("Search content cleared");
            },
            onVoiceSearchTap: () {
              print("Microphone tapped");
            },
            isOnSearchPage: false, // Đang ở ProductPage
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutesNames.FILTER, // Điều hướng tới màn hình filter
            );
          },
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

// Bộ lọc danh mục sản phẩm
Widget categoryFilter({
  required List<String> categories,
  required String selectedCategory,
  required Function(String) onCategorySelected,
}) {
  final updatedCategories = ["Tất cả", ...categories];

  return SizedBox(
    height: 55.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: updatedCategories.length,
      itemBuilder: (context, index) {
        String category = updatedCategories[index];
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 16.w : 5.w),
          child: _buildCategoryButton(
            category,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          ),
        );
      },
    ),
  );
}

Widget _buildCategoryButton(String title, {required bool isSelected, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: text16Bold(
          text: title,
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      ),
    ),
  );
}

Widget productList({
  required int currentPage,
  required String selectedCategory,
  required Function(int) onPageChange,
  required WidgetRef ref,
}) {
  final productState = ref.watch(productNotifierProvider); // Lấy trạng thái sản phẩm

  return productState.when(
    data: (products) {
      // Sử dụng ref.watch() để lấy các phương thức của StateNotifier
      final filteredProducts = ref.read(productNotifierProvider.notifier).filterByCategory(selectedCategory);

      if (filteredProducts.isEmpty) {
        return const Center(
          child: Text("Không có sản phẩm trong danh mục này"),
        );
      }

      return Column(
        children: [
          buildProductGrid(filteredProducts, currentPage),
          buildPagination(filteredProducts.length, currentPage, (int newPage) {
            onPageChange(newPage); // Gọi callback để chuyển trang
          }),
        ],
      );
    },
    loading: () => const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
        color: AppColors.primary,
      ),
    ),
    error: (error, _) => Center(
      child: Text('Error: $error'),
    ),
  );
}

Widget buildProductGrid(List<Vehicle> products, int currentPage) {
  int productsPerPage = 10;
  int totalPages = (products.length / productsPerPage).ceil();

  if (currentPage >= totalPages) {
    currentPage = totalPages - 1;
  }

  int startIndex = currentPage * productsPerPage;
  int endIndex = (startIndex + productsPerPage) > products.length
      ? products.length
      : startIndex + productsPerPage;

  List<Vehicle> currentProducts = products.sublist(startIndex, endIndex);

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.w,
        crossAxisSpacing: 16.w,
        childAspectRatio: 0.68,
      ),
      itemCount: currentProducts.length,
      itemBuilder: (context, index) {
        var product = currentProducts[index];
        return productItem(product: product, context: context);
      },
    ),
  );
}

Widget buildPagination(int totalProducts, int currentPage, Function(int) onPageChange) {
  int productsPerPage = 10;
  int totalPages = (totalProducts / productsPerPage).ceil();
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Opacity(
        opacity: currentPage > 0 ? 1.0 : 0,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 0 ? () => onPageChange(currentPage - 1) : null,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('Trang ${currentPage + 1} / $totalPages'),
      ),
      Opacity(
        opacity: currentPage < totalPages - 1 ? 1.0 : 0,
        child: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1 ? () => onPageChange(currentPage + 1) : null,
        ),
      ),
    ],
  );
}

Widget productItem({required BuildContext context, required Vehicle product}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        AppRoutesNames.PRODUCT_DETAIL,
        arguments: product,
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
              height: 150.h,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.vehicleName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    product.version,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
