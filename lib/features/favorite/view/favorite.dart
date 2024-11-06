import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/features/favorite/view/widgets/favorite_widget.dart';
import 'package:radicalcare/features/filtered_product/view/widgets/filtered_product_widget.dart';
import '../../product/provider/product_notifier.dart';
import '../../product_detail/view/product_detail.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProductsAsync = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sản phẩm yêu thích'),
      ),
      body: favoriteProductsAsync.when(
        data: (favoriteProducts) {
          if (favoriteProducts.isEmpty) {
            return const Center(child: Text('Chưa có sản phẩm yêu thích.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: favoriteProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final vehicle = favoriteProducts[index];
                return vehicleItemWidgetFavor(
                  vehicle: vehicle,
                  onTap: () {
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
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
