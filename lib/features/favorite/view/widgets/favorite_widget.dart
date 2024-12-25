import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../common/model/vehicle_model.dart';
import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/text_widgets.dart';
import '../../../product/product_page/provider/product_notifier.dart';

Widget vehicleItemWidgetFavor({
  required Vehicle vehicle,
  required VoidCallback onTap,
  required WidgetRef ref,
}) {
  final baseCostAsync = ref.watch(baseCostProvider(vehicle.costId));

  return baseCostAsync.when(
    data: (baseCost) {
      final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(baseCost);

      return GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                  child: Image.network(
                    vehicle.imageUrls.isNotEmpty ? vehicle.imageUrls.first : 'assets/images/default_image.png',
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: text16Bold(text: vehicle.vehicleName, color: AppColors.secondary),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: text14Bold(text: formattedPrice, color: AppColors.secondary),
              ),
            ],
          ),
        ),
      );
    },
    loading: () => const CircularProgressIndicator(),
    error: (error, stack) => Text("Error: $error"),
  );
}
