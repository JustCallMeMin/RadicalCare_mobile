import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../common/model/vehicle.dart';
import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/text_widgets.dart';

Widget filterVehicleItemWidget({
  required Vehicle vehicle,
  required VoidCallback onTap,
  required WidgetRef ref,
}) {
  final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(vehicle.baseCost);
  print('Base cost: ${vehicle.baseCost}'); // Debug giá trị baseCost
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
}
