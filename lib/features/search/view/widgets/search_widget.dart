import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/model/vehicle.dart';
import '../../../../common/widgets/app_textfieds.dart';
import '../../../filtered_product/view/widgets/filtered_product_widget.dart';

Widget searchBarOnSearchPage({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController searchController,
  required Function(String) onSearch,
  required Function() onTapSearchBar, // Hàm gọi khi nhấn vào thanh tìm kiếm
  required Function() onClearSearch, // Hàm gọi khi nội dung bị xóa
  required FocusNode focusNode, // FocusNode để giữ focus
}) {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              print("Search bar tapped"); // Debug log
              focusNode.requestFocus(); // Đảm bảo focus vào thanh tìm kiếm
              onTapSearchBar(); // Gọi hàm để load recentSearches
            },
            child: appSearchBar(
              context: context,
              hintText: 'Nhập từ khóa tìm kiếm...', // Placeholder của thanh tìm kiếm
              searchController: searchController,
              focusNode: focusNode, // Gắn FocusNode vào
              onSearch: onSearch, // Gọi hàm tìm kiếm khi nhấn Enter
              onClearSearch: onClearSearch, // Gọi hàm khi nội dung bị xóa
              onVoiceSearchTap: () {
                print("Microphone tapped"); // Debug cho chức năng giọng nói
              },
              isOnSearchPage: true, // Xác định rằng đang ở SearchPage
            ),
          ),
        ),
      ],
    ),
  );
}

Widget productListResult({
  required List<Vehicle> searchResults,
  required Function(Vehicle) onItemTap,
  required WidgetRef ref,
}) {
  if (searchResults.isEmpty) {
    return Center(
      child: Text(
        'Không tìm thấy kết quả nào!',
        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
      ),
    );
  }

  return Column(
    children: [
      // GridView hiển thị kết quả
      Expanded(
        child: GridView.builder(
          padding: EdgeInsets.all(8.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Số cột trong grid
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.7,
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final vehicle = searchResults[index];
            return filterVehicleItemWidget(
              vehicle: vehicle,
              onTap: () => onItemTap(vehicle),
              ref: ref,
            );
          },
        ),
      ),
    ],
  );
}
