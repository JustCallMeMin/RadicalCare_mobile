import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import '../../../../common/utils/images.dart';
import '../../../../common/widgets/app_textfieds.dart';

// Thanh tìm kiếm sử dụng appSearchBar
Widget searchBar() {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Row(
      children: [
        Expanded(
          child: appSearchBar(
            hintText: 'Tìm kiếm sản phẩm...',
            onSearch: (value) {
              print("Người dùng tìm kiếm: $value");
            },
            onVoiceSearchTap: () {
              print("Microphone tapped");
            },
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    ),
  );
}

// Bộ lọc danh mục sản phẩm
Widget categoryFilter({required String selectedCategory, required Function(String) onCategorySelected}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h),
    child: SizedBox(
      height: 50.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCategoryButton("Tất cả", isSelected: selectedCategory == "Tất cả", onTap: () => onCategorySelected("Tất cả")),
          _buildCategoryButton("Sản phẩm 1", isSelected: selectedCategory == "Sản phẩm 1", onTap: () => onCategorySelected("Sản phẩm 1")),
          _buildCategoryButton("Sản phẩm 2", isSelected: selectedCategory == "Sản phẩm 2", onTap: () => onCategorySelected("Sản phẩm 2")),
          _buildCategoryButton("Sản phẩm 3", isSelected: selectedCategory == "Sản phẩm 3", onTap: () => onCategorySelected("Sản phẩm 3")),
          _buildCategoryButton("Sản phẩm 4", isSelected: selectedCategory == "Sản phẩm 4", onTap: () => onCategorySelected("Sản phẩm 4")),
        ],
      ),
    ),
  );
}

// Tạo nút danh mục
Widget _buildCategoryButton(String title, {required bool isSelected, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap, // Khi người dùng nhấn vào button
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

// Danh sách sản phẩm theo danh mục và phân trang
Widget productList({
  required int currentPage,
  required String selectedCategory,
  required Function(int) onPageChange,  // Thêm tham số onPageChange
}) {
  // Tạo một danh sách sản phẩm mẫu
  List<Map<String, String>> allProducts = [
    {"image": AppImages.service1, "title": "Product 1", "category": "Sản phẩm 1", "price": "\$100"},
    {"image": AppImages.service2, "title": "Product 2", "category": "Sản phẩm 1", "price": "\$200"},
    {"image": AppImages.service3, "title": "Product 3", "category": "Sản phẩm 2", "price": "\$300"},
    {"image": AppImages.service1, "title": "Product 4", "category": "Sản phẩm 2", "price": "\$400"},
    {"image": AppImages.service2, "title": "Product 2", "category": "Sản phẩm 3", "price": "\$500"},
    {"image": AppImages.service1, "title": "Product 1", "category": "Sản phẩm 1", "price": "\$100"},
    {"image": AppImages.service2, "title": "Product 2", "category": "Sản phẩm 1", "price": "\$200"},
    {"image": AppImages.service3, "title": "Product 3", "category": "Sản phẩm 2", "price": "\$300"},
    {"image": AppImages.service1, "title": "Product 4", "category": "Sản phẩm 2", "price": "\$400"},
    {"image": AppImages.service2, "title": "Product 1", "category": "Sản phẩm 3", "price": "\$500"},
    {"image": AppImages.service1, "title": "Product 1", "category": "Sản phẩm 1", "price": "\$100"},
    {"image": AppImages.service2, "title": "Product 2", "category": "Sản phẩm 1", "price": "\$200"},
    {"image": AppImages.service3, "title": "Product 3", "category": "Sản phẩm 4", "price": "\$300"},
    {"image": AppImages.service1, "title": "Product 4", "category": "Sản phẩm 4", "price": "\$400"},
    {"image": AppImages.service2, "title": "Product 3", "category": "Sản phẩm 3", "price": "\$500"},
    {"image": AppImages.service1, "title": "Product 1", "category": "Sản phẩm 4", "price": "\$100"},
    {"image": AppImages.service2, "title": "Product 2", "category": "Sản phẩm 4", "price": "\$200"},
    {"image": AppImages.service3, "title": "Product 3", "category": "Sản phẩm 4", "price": "\$300"},
    {"image": AppImages.service1, "title": "Product 4", "category": "Sản phẩm 2", "price": "\$400"},
    {"image": AppImages.service2, "title": "Product 1", "category": "Sản phẩm 1", "price": "\$500"},
    // Thêm sản phẩm khác vào đây
  ];

  // Lọc sản phẩm theo danh mục
  List<Map<String, String>> filteredProducts = selectedCategory == "Tất cả"
      ? allProducts
      : allProducts.where((product) => product["category"] == selectedCategory).toList();

  // Số sản phẩm mỗi trang
  int productsPerPage = 6;
  int totalProducts = filteredProducts.length;
  int totalPages = (totalProducts / productsPerPage).ceil();
  int startIndex = currentPage * productsPerPage;
  int endIndex = (startIndex + productsPerPage) > totalProducts ? totalProducts : (startIndex + productsPerPage);

  // Nếu không còn sản phẩm, hiển thị thông báo
  if (totalProducts == 0) {
    return Center(child: Text("Không có sản phẩm trong danh mục này"));
  }

  // Nếu chỉ số trang vượt quá số sản phẩm, đặt lại về trang cuối
  if (currentPage >= totalPages) {
    onPageChange(totalPages - 1);
  }

  // Lấy danh sách sản phẩm cho trang hiện tại
  List<Map<String, String>> currentProducts = filteredProducts.sublist(startIndex, endIndex);

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.w,
            crossAxisSpacing: 16.w,
            childAspectRatio: 0.75,
          ),
          itemCount: currentProducts.length,
          itemBuilder: (context, index) {
            var product = currentProducts[index];
            return productItem(
              imagePath: product["image"]!,
              title: product["title"]!,
              price: product["price"]!,
            );
          },
        ),
      ),
      SizedBox(height: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nút trang trước (chỉ hiển thị khi không ở trang đầu)
          if (currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => onPageChange(currentPage - 1),
            ),

          // Hiển thị số trang
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Trang ${currentPage + 1} / $totalPages'),
          ),

          // Nút trang sau (chỉ hiển thị khi chưa phải trang cuối)
          if (currentPage < totalPages - 1)
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => onPageChange(currentPage + 1),
            ),
        ],
      ),
    ],
  );
}

// Thành phần sản phẩm
Widget productItem({
  required String imagePath,
  required String title,
  required String price,
  String? discountPrice,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Stack(
      children: [
        // Hình ảnh sản phẩm
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (discountPrice != null)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Text(
                            discountPrice,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // Biểu tượng yêu thích
        Positioned(
          top: 10.h,
          right: 10.w,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
