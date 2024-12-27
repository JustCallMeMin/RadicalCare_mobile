import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../filter/provider/filter_notifier.dart';
import '../../product_detail/view/product_detail.dart';
import 'widgets/filtered_product_widget.dart';

class FilteredProductScreen extends ConsumerWidget {
  const FilteredProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sản phẩm đã lọc'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: filterState.when(
        data: (vehicles) {
          if (vehicles == null || vehicles.isEmpty) {
            return const Center(child: Text('Không tìm thấy sản phẩm.'));
          }
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: GridView.builder(
              itemCount: vehicles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số cột trong grid
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 0.7, // Tỉ lệ giữa chiều rộng và chiều cao của mỗi ô
              ),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return filterVehicleItemWidget(
                  vehicle: vehicle,
                  onTap: () {
                    // Điều hướng đến trang chi tiết sản phẩm khi nhấn vào
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: vehicle.chassisNumber),
                      ),
                    );
                  },
                  ref: ref,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }
}
