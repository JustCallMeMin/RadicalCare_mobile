import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/api/product_api.dart'; // API để lấy dữ liệu sản phẩm
import 'package:radicalcare/common/model/vehicle.dart';

import '../../../common/model/cost_table.dart';

part 'product_notifier.g.dart';

// Provider để lấy baseCost từ CostTable dựa trên costId
final baseCostProvider = FutureProvider.family<double, int>((ref, costId) async {
  // Thay thế với API thực tế hoặc nguồn dữ liệu khác cho CostTable
  final response = await fetchCostById(costId); // Implement API call
  return response.baseCost ?? 0.0;
});

// Notifier cho việc quản lý danh mục sản phẩm được chọn
@riverpod
class ProductCategory extends _$ProductCategory {
  @override
  String build() {
    return "Tất cả";  // Mặc định khởi tạo danh mục là "Tất cả"
  }

  // Cập nhật danh mục sản phẩm
  void updateCategory(String newCategory) {
    state = newCategory;  // Cập nhật danh mục mới
  }
}

// Notifier cho việc quản lý dữ liệu sản phẩm
@riverpod
class ProductNotifier extends _$ProductNotifier {
  late List<Vehicle> allProducts;

  @override
  Future<List<Vehicle>> build() async {
    return await _fetchAllProducts();
  }

  // Hàm lấy tất cả sản phẩm từ API
  Future<List<Vehicle>> _fetchAllProducts() async {
    allProducts = await fetchVehicles(); // Gọi API để lấy sản phẩm
    return allProducts;
  }

  // Lọc sản phẩm theo danh mục
  List<Vehicle> filterByCategory(String category) {
    if (category == "Tất cả") {
      return allProducts;
    } else {
      int selectedCategoryId = _getCategoryIdByName(category);
      return allProducts.where((product) => product.categoryId == selectedCategoryId).toList();
    }
  }

  // Lấy ID danh mục dựa trên tên danh mục
  int _getCategoryIdByName(String categoryName) {
    switch (categoryName) {
      case "Xe tay ga":
        return 1;
      case "Xe số":
        return 2;
      case "Xe côn tay":
        return 3;
      case "Xe mô tô phân khối lớn":
        return 4;
      case "Xe điện":
        return 5;
      case "Xe địa hình":
        return 6;
      case "Xe cổ điển":
        return 7;
      case "Xe tay côn phân khối lớn":
        return 8;
      case "Xe thể thao":
        return 9;
      case "Xe Touring":
        return 10;
      default:
        return -1;
    }
  }
}

// Notifier cho việc quản lý số trang sản phẩm hiện tại
@riverpod
class ProductPage extends _$ProductPage {
  @override
  int build() {
    return 0; // Khởi tạo trang 0
  }

  void nextPage() => state++; // Chuyển trang tiếp theo
  void previousPage() => state--; // Quay về trang trước
  void setPage(int page) => state = page; // Đặt trang hiện tại
}

@riverpod
class ProductDetailNotifier extends _$ProductDetailNotifier {
  Vehicle? product;

  @override
  Future<Vehicle> build(String productId) async {
    product = await fetchVehicleById(productId); // Lấy chi tiết sản phẩm
    return product!;
  }
}

@riverpod
class ImageNotifier extends _$ImageNotifier {
  @override
  int build() {
    return 0; // Khởi tạo chỉ số hình ảnh là 0 (ảnh đầu tiên)
  }

  // Cập nhật hình ảnh được chọn
  void setImageIndex(int index) {
    state = index;
  }
}

// Notifier cho danh sách yêu thích
final favoriteNotifierProvider = StateNotifierProvider<FavoriteNotifier, AsyncValue<List<Vehicle>>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  FavoriteNotifier() : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = <Vehicle>[]; // Thay thế bằng logic lấy danh sách yêu thích nếu có
      state = AsyncValue.data(favorites);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void toggleFavorite(Vehicle vehicle) {
    state.whenData((favoriteProducts) {
      final updatedFavorites = favoriteProducts.contains(vehicle)
          ? favoriteProducts.where((v) => v.chassisNumber != vehicle.chassisNumber).toList()
          : [...favoriteProducts, vehicle];
      state = AsyncValue.data(updatedFavorites);
    });
  }
}