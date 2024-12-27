import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/secure_storage.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../../../../../../common/model/vehicle_model.dart';
import '../../../../../common/model/cart_item_model.dart';
import '../../../../cart/provider/cart_page_notifier.dart';
import '../../../product_page/provider/product_notifier.dart';

// Widget cho phần tiêu đề với nút yêu thích
Widget productDetailHeader({
  required BuildContext context,
  required WidgetRef ref, // Thêm ref vào
  required Vehicle product,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Nút quay lại
      Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: IconButton(
            icon: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      // Tiêu đề
      text18Bold(text: "Chi tiết sản phẩm", color: AppColors.secondary),
      // Nút yêu thích
      Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Consumer(
            builder: (context, ref, _) {
              // Lấy `FavoriteNotifier` từ `favoriteNotifierProvider`
              final isFavorite = ref.watch(
                favoriteNotifierProvider.select(
                  (state) =>
                      state is AsyncData &&
                      state.value!
                          .any((v) => v.chassisNumber == product.chassisNumber),
                ),
              );
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primary : Colors.white,
                ),
                onPressed: () {
                  // Thực hiện toggleFavorite để thay đổi trạng thái yêu thích
                  ref
                      .read(favoriteNotifierProvider.notifier)
                      .toggleFavorite(product);
                },
              );
            },
          ),
        ),
      ),
    ],
  );
}

// Widget cho hình ảnh sản phẩm chính và ảnh thu nhỏ
class ProductImages extends ConsumerWidget {
  final List<String> imageUrls;

  const ProductImages({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImageIndex =
        ref.watch(imageNotifierProvider); // Lấy chỉ số hình ảnh hiện tại
    final pageController = PageController(initialPage: selectedImageIndex);

    return Column(
      children: [
        // Hiển thị ảnh lớn với PageView
        SizedBox(
          height: 350.h,
          width: double.infinity,
          child: PageView.builder(
            controller: pageController,
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              ref
                  .read(imageNotifierProvider.notifier)
                  .setImageIndex(index); // Cập nhật hình ảnh hiện tại
            },
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls.isNotEmpty
                    ? imageUrls[index]
                    : 'assets/images/default_image.png',
                fit: BoxFit.fitWidth,
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        // Hiển thị ảnh thu nhỏ bên dưới
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(imageUrls.length, (index) {
              return GestureDetector(
                onTap: () {
                  ref.read(imageNotifierProvider.notifier).setImageIndex(
                      index); // Cập nhật ảnh khi nhấn vào ảnh thu nhỏ
                  pageController.jumpToPage(index); // Nhảy đến trang tương ứng
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedImageIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      imageUrls[index],
                      height: 60.h,
                      width: 60.w,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

final quantityProvider = StateProvider<int>((ref) => 1);
// Widget thông tin sản phẩm
Widget productInfo(
    String title, String version, Vehicle product, WidgetRef ref) {
  final quantity = ref.watch(quantityProvider);

  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.segment,
          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        text16Bold(text: "Chi tiết sản phẩm", color: AppColors.secondary),
        SizedBox(height: 4.h),
        Text(
          product.description,
          style: TextStyle(fontSize: 14.sp, height: 1.5),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Số lượng:",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            SizedBox(width: 16.w),
            IconButton(
              icon: Icon(Icons.remove, size: 20.sp),
              onPressed: quantity > 1
                  ? () => ref.read(quantityProvider.notifier).state -= 1
                  : null,
            ),
            Text(
              '$quantity',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            IconButton(
              icon: Icon(Icons.add, size: 20.sp),
              onPressed: () => ref.read(quantityProvider.notifier).state += 1,
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget chọn màu
// Widget productColorSelector() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Select Color : Brown",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
//         ),
//         SizedBox(height: 8.h),
//         Row(
//           children: List.generate(5, (index) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: CircleAvatar(
//                 radius: 18.w,
//                 backgroundColor: [Colors.brown, Colors.orange, Colors.pink, Colors.black, Colors.grey][index],
//               ),
//             );
//           }),
//         ),
//       ],
//     ),
//   );
// }

// Widget nút thêm vào giỏ hàng
Widget addToCartButton(BuildContext context, Vehicle product, WidgetRef ref) {
  final baseCostAsync = ref.watch(baseCostProvider(product.costId));

  return baseCostAsync.when(
    data: (baseCost) {
      try {
        // Format giá và log kết quả
        final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(baseCost);
        debugPrint("Base cost fetched: $baseCost");
        debugPrint("Formatted price: $formattedPrice");

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text16Bold(text: "Giá: $formattedPrice", color: AppColors.secondary),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final userId = await SecureStorageManager.getUserId();
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng đăng nhập trước!")),
                      );
                      return;
                    }

                    final quantity = ref.read(quantityProvider);
                    await ref
                        .read(cartPageNotifierProvider.notifier)
                        .addToTemporaryCart(product.chassisNumber, quantity);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đã thêm $quantity sản phẩm vào giỏ hàng!")),
                    );
                  } catch (e, stackTrace) {
                    debugPrint("Error adding product to cart: $e");
                    debugPrint("StackTrace: $stackTrace");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Thêm sản phẩm thất bại: $e")),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                label: const Text("Bỏ vào giỏ hàng", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        );
      } catch (e, stackTrace) {
        debugPrint("Error formatting baseCost: $e");
        debugPrint("StackTrace: $stackTrace");
        return Center(
          child: Text(
            "Giá không khả dụng",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        );
      }
    },
    loading: () {
      debugPrint("Loading base cost for product ID: ${product.costId}");
      return const Center(child: CircularProgressIndicator());
    },
    error: (error, stackTrace) {
      debugPrint("Error fetching base cost: $error");
      debugPrint("StackTrace: $stackTrace");
      return Center(
        child: Text(
          'Không thể tải giá: ${error.toString()}',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
    },
  );
}

