import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/common/utils/images.dart';

// Tiêu đề của trang
Widget homepageTitle({required String text}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: text32Bold(text: text, color: AppColors.secondary),
  );
}

// Thanh tìm kiếm
Widget searchBar() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search for clothes...",
        prefixIcon: Icon(Icons.search, color: AppColors.secondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

// Danh mục sản phẩm
Widget categorySelector() {
  List<String> categories = ["All", "Tshirts", "Jeans", "Shoes"];
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map((category) => ChoiceChip(
        label: Text(category),
        selected: category == "Tshirts", // Chọn mặc định
        onSelected: (bool selected) {},
      ))
          .toList(),
    ),
  );
}

// Lưới sản phẩm
Widget productGrid() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 4, // Số lượng sản phẩm
      itemBuilder: (context, index) {
        return productCard();
      },
    ),
  );
}

// Thẻ sản phẩm
Widget productCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              AppImages.sampleProduct,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text16Normal(text: "Regular Fit Polo", color: AppColors.secondary),
              text14Normal(text: "\$1,100", color: Colors.grey),
            ],
          ),
        ),
      ],
    ),
  );
}

// Lời mời gọi hành động
Widget callToAction() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.primary,
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      onPressed: () {
        // Xử lý khi nhấn nút
      },
      child: text16Normal(text: "Đặt ngay", color: Colors.white),
    ),
  );
}

// Phần thông tin thêm
Widget additionalInfoSection() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text24Normal(text: "Cung Cấp Giải Pháp Đổi Mới & Bền Vững"),
        SizedBox(height: 8.h),
        text14Normal(
          text:
          "Chúng tôi cam kết mang đến các giải pháp tiên tiến và thân thiện với môi trường trong việc bảo dưỡng và sửa chữa xe máy.",
        ),
      ],
    ),
  );
}
