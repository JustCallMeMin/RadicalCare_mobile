import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/features/product/product_detail/view/widgets/product_deatail_widgets.dart';
import '../provider/product_detail_notifier.dart';

class ProductDetailPage extends ConsumerWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetail = ref.watch(productDetailNotifierProvider(productId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: productDetail.when(
        data: (product) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Stack(
                  children: [
                    ProductImages(imageUrls: product.imageUrls),
                    productDetailHeader(context: context, ref: ref, product: product),
                  ],
                ),
                // Truyền thêm `ref` vào hàm `productInfo`
                productInfo(product.vehicleName, product.version, product, ref),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: productDetail.when(
        data: (product) => addToCartButton(context, product, ref),
        loading: () => const SizedBox.shrink(),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }
}
