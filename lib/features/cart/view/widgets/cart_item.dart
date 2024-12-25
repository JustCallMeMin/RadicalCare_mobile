import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/model/cart_item_model.dart';

import '../../provider/cart_page_notifier.dart';

class CartItemWidget extends ConsumerWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                cartItem.vehicle.imageUrls.isNotEmpty
                    ? cartItem.vehicle.imageUrls[0]
                    : 'https://via.placeholder.com/150',
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.vehicle.vehicleName,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Giá: ${cartItem.vehicle.baseCost.toStringAsFixed(2)} VNĐ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      // Decrease Quantity
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline, size: 20.sp),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            final newQuantity = cartItem.quantity - 1;
                            ref
                                .read(cartPageNotifierProvider.notifier)
                                .updateTemporaryCartItem(cartItem.id, newQuantity);
                          }
                        },
                      ),
                      // Display Quantity
                      Text(
                        '${cartItem.quantity}',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      // Increase Quantity
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, size: 20.sp),
                        onPressed: () {
                          final newQuantity = cartItem.quantity + 1;
                          ref
                              .read(cartPageNotifierProvider.notifier)
                              .updateTemporaryCartItem(cartItem.id, newQuantity);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 24.sp),
              onPressed: () async {
                await ref
                    .read(cartPageNotifierProvider.notifier)
                    .removeFromCart(cartItem.id);
                await ref.read(cartPageNotifierProvider.notifier).fetchTemporaryCartItems();
              },
            ),
          ],
        ),
      ),
    );
  }
}
