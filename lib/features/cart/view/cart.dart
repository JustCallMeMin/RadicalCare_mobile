import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import '../../../../common/model/cart_item_model.dart';
import '../../application/provider/application_notifier.dart';
import '../../application/view/application.dart';
import '../provider/cart_page_notifier.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(applicationNotifierProvider.notifier).hideBottomBar();
    });

    final cartAsyncValue = ref.watch(cartPageNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: text18Bold(text: 'Giỏ hàng', color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.read(applicationNotifierProvider.notifier).showBottomBar();
            ref.read(currentIndexNotifierProvider.notifier).resetIndex();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Application()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartAsyncValue.when(
              data: (cartItems) {
                return _buildCartContent(context, ref, cartItems);
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stackTrace) {
                return Center(child: Text('Lỗi: $error'));
              },
            ),
          ),
          _buildBottomCheckoutBar(context, ref),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, WidgetRef ref, List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      return Center(
        child: text16Bold(text: "Giỏ hàng trống", color: Colors.grey),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    item.vehicle.imageUrls.isNotEmpty ? item.vehicle.imageUrls[0] : '',
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text16Bold(text: item.vehicle.vehicleName, color: Colors.black),
                      SizedBox(height: 4.h),
                      Text(
                        'Giá: ${_formatCurrency(item.subtotal)} VNĐ',
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                            onPressed: () {
                              if (item.quantity > 1) {
                                ref.read(cartPageNotifierProvider.notifier).updateTemporaryCartItem(
                                  item.id,
                                  item.quantity - 1,
                                );
                              }
                            },
                          ),
                          text16Bold(text: '${item.quantity}', color: Colors.black),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                            onPressed: () {
                              ref.read(cartPageNotifierProvider.notifier).updateTemporaryCartItem(
                                item.id,
                                item.quantity + 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(cartPageNotifierProvider.notifier).removeFromCart(item.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomCheckoutBar(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.watch(cartPageNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng tạm tính: ${_formatCurrency(cartNotifier.totalCost)} VNĐ',
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
          ),
          SizedBox(height: 4.h),
          // Text(
          //   'Phí giao hàng: ${_formatCurrency(25000)} VNĐ',
          //   style: TextStyle(fontSize: 14.sp, color: Colors.black),
          // ),
          // SizedBox(height: 4.h),
          // Text(
          //   'Giảm giá: ${_formatCurrency(-35000)} VNĐ',
          //   style: TextStyle(fontSize: 14.sp, color: Colors.black),
          // ),
          // SizedBox(height: 8.h),
          Text(
            'Tổng cộng: ${_formatCurrency(cartNotifier.totalCost )} VNĐ',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              _showCheckoutBottomSheet(context, cartNotifier);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              backgroundColor: const Color(0xFFE64A19),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Center(
              child: text16Bold(text: 'Thanh toán', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCheckoutBottomSheet(BuildContext context, CartPageNotifier notifier) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final totalCost = notifier.totalCost;
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Text(
                'Tổng cộng: ${_formatCurrency(totalCost + 25000 - 35000)} VNĐ',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Logic thanh toán
                },
                child: const Text('Xác nhận thanh toán'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
    );
  }
}
