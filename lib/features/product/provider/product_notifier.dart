import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/api/product_api.dart'; // API để lấy dữ liệu sản phẩm
import 'package:radicalcare/common/model/vehicle.dart';

import '../../../common/model/category.dart';
import '../../../common/model/cost_table.dart';
import '../../../common/utils/secure_storage.dart';

part 'product_notifier.g.dart';

// Provider để lấy baseCost từ CostTable dựa trên costId
final baseCostProvider =
    FutureProvider.family<double, int>((ref, costId) async {
  final response = await fetchCostById(costId); // Thực hiện API call
  return response.baseCost ?? 0.0;
});

// Notifier cho việc quản lý danh mục sản phẩm được chọn
@riverpod
class ProductCategory extends _$ProductCategory {
  @override
  String build() {
    return "Tất cả"; // Mặc định khởi tạo danh mục là "Tất cả"
  }

  // Cập nhật danh mục sản phẩm
  void updateCategory(String newCategory) {
    state = newCategory; // Cập nhật danh mục mới
  }
}

// Notifier cho việc quản lý dữ liệu sản phẩm
@riverpod
class ProductNotifier extends _$ProductNotifier {
  late List<Vehicle> allProducts;
  late Map<String, int> categoryMap; // Lưu ánh xạ categoryName -> categoryId

  // Khởi tạo và lấy sản phẩm cho trang đầu tiên
  @override
  Future<AsyncValue<List<Vehicle>>> build() async {
    await _fetchCategories();
    return await _fetchProducts(0, 10); // Lấy sản phẩm cho trang đầu tiên
  }

  // Lấy danh mục và ánh xạ categoryName -> categoryId
  Future<void> _fetchCategories() async {
    try {
      final response = await fetchCategories();
      if (response["success"] == true) {
        final List<dynamic> data = response["data"];
        final List<Category> fetchedCategories =
            data.map((json) => Category.fromJson(json)).toList();

        categoryMap = {
          for (var category in fetchedCategories) category.name: category.id
        };
      }
    } catch (e) {
      print("Failed to fetch categories: $e");
    }
  }

  // Lấy sản phẩm cho một trang cụ thể
  Future<AsyncValue<List<Vehicle>>> _fetchProducts(int page, int size) async {
    try {
      final response = await fetchVehicles(page: page, size: size);
      allProducts = response;
      return AsyncValue.data(allProducts); // Trả về AsyncValue.data
    } catch (e, stackTrace) {
      return AsyncValue.error(
          e, stackTrace); // Nếu có lỗi, trả về AsyncValue.error
    }
  }

  // Lọc sản phẩm theo danh mục
  List<Vehicle> filterByCategory(String categoryName) {
    // Lấy ID danh mục từ categoryMap
    final int? categoryId = categoryMap[categoryName];

    // Kiểm tra nếu categoryId có tồn tại
    if (categoryId == null) {
      // Nếu không có danh mục, trả về tất cả sản phẩm
      return allProducts;
    }

    // Lọc toàn bộ sản phẩm theo categoryId, không phụ thuộc vào phân trang
    return allProducts.where((product) => product.categoryId == categoryId).toList();
  }


  // Lấy sản phẩm cho trang mới
  Future<void> fetchProductsForPage(int page) async {
    try {
      state = const AsyncValue.loading(); // Đảm bảo trạng thái là loading
      final response = await _fetchProducts(page, 10);
      print('Fetched products: $response'); // Debug log
      state = AsyncValue.data(response); // Cập nhật state với dữ liệu
    } catch (e, stackTrace) {
      print('Error fetching products: $e'); // Debug log
      print('StackTrace: $stackTrace'); // Debug log stackTrace
      state = AsyncValue.error(e, stackTrace); // Truyền cả error và stackTrace
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
final favoriteNotifierProvider =
    StateNotifierProvider<FavoriteNotifier, AsyncValue<List<Vehicle>>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  FavoriteNotifier() : super(const AsyncValue.loading()) {
    _loadFavorites(); // Tải danh sách yêu thích từ SecureStorage khi khởi tạo
  }

  // Hàm tải danh sách yêu thích từ SecureStorage
  Future<void> _loadFavorites() async {
    try {
      final favorites = await SecureStorageManager
          .getFavoriteProducts(); // Lấy dữ liệu từ SecureStorage
      state = AsyncValue.data(favorites);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Hàm thêm hoặc xóa sản phẩm khỏi danh sách yêu thích
  void toggleFavorite(Vehicle vehicle) async {
    state.whenData((favoriteProducts) async {
      List<Vehicle> updatedFavorites;

      if (favoriteProducts
          .any((v) => v.chassisNumber == vehicle.chassisNumber)) {
        // Nếu sản phẩm đã tồn tại, loại bỏ nó
        updatedFavorites = favoriteProducts
            .where((v) => v.chassisNumber != vehicle.chassisNumber)
            .toList();
      } else {
        // Nếu chưa tồn tại, thêm sản phẩm vào danh sách
        updatedFavorites = [...favoriteProducts, vehicle];
      }

      // Cập nhật trạng thái
      state = AsyncValue.data(updatedFavorites);

      // Lưu vào SecureStorage
      await SecureStorageManager.saveFavoriteProducts(updatedFavorites);
    });
  }

  // Hàm xóa toàn bộ danh sách yêu thích
  Future<void> clearFavorites() async {
    state = const AsyncValue.data([]); // Xóa trong trạng thái
    await SecureStorageManager.clearAllData(); // Xóa trong SecureStorage
  }
}
