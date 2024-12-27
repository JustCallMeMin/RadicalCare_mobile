import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/model/vehicle_model.dart';
import '../../../../../common/api/product_api.dart';

part 'product_detail_notifier.g.dart';

@riverpod
class ProductDetailNotifier extends _$ProductDetailNotifier {
  Vehicle? product;

  @override
  Future<Vehicle> build(String productId) async {
    return await _fetchProductDetail(productId); // Gọi hàm để lấy chi tiết sản phẩm
  }

  // Lấy chi tiết sản phẩm theo ID từ API
  Future<Vehicle> _fetchProductDetail(String productId) async {
    try {
      product = await fetchVehicleById(productId);
      return product!;
    } catch (error) {
      throw Exception('Failed to fetch product details: $error');
    }
  }
}
