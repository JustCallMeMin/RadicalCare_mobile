import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/api/product_api.dart'; // API để lấy dữ liệu sản phẩm
import 'package:radicalcare/common/model/vehicle_model.dart';

import '../../../../common/api/cost_table_api.dart';
import '../../../../common/model/category_model.dart';
import '../../../../common/model/cost_table_model.dart';
import '../../../../common/utils/secure_storage.dart';

part 'product_notifier.g.dart';

// Provider để lấy baseCost từ CostTable dựa trên costId

final baseCostProvider = AutoDisposeFutureProvider.family<double, int>((ref, costId) async {
  return await CostApi.fetchBaseCostById(costId);
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

  // Khởi tạo, lấy categories và toàn bộ dữ liệu xe
  @override
  Future<AsyncValue<List<Vehicle>>> build() async {
    await _fetchCategories();
    await _fetchAllProducts(); // Lấy toàn bộ xe 1 lần
    return AsyncValue.data(allProducts); // Trả về toàn bộ dữ liệu
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

  Future<void> _fetchAllProducts() async {
    try {
      // Gọi endpoint mới để lấy tất cả vehicles
      final allProductsResponse = await fetchAllVehicles();
      allProducts = allProductsResponse; // Lưu tất cả xe vào allProducts
    } catch (e) {
      print("Failed to fetch all vehicles: $e");
    }
  }

  // Lọc sản phẩm theo danh mục
  List<Vehicle> filterByCategory(String categoryName) {
    final int? categoryId = categoryMap[categoryName];
    if (categoryId == null) {
      // Category "Tất cả" hoặc không tìm thấy -> trả về toàn bộ
      return allProducts;
    }
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  // Lấy danh sách sản phẩm đã lọc theo category và phân trang trên FE
  List<Vehicle> getPaginatedFilteredProducts(String categoryName, int currentPage, int pageSize) {
    final filtered = filterByCategory(categoryName);
    final totalItems = filtered.length;

    // Nếu số lượng sản phẩm <= pageSize, không phân trang, trả về toàn bộ
    if (totalItems <= pageSize) {
      return filtered;
    }

    // Cần phân trang
    final totalPages = (totalItems / pageSize).ceil();

    // Đảm bảo currentPage hợp lệ
    int validPage = currentPage;
    if (validPage < 0) {
      validPage = 0;
    } else if (validPage >= totalPages) {
      validPage = totalPages - 1;
    }

    final startIndex = validPage * pageSize;
    int endIndex = startIndex + pageSize;
    if (endIndex > totalItems) {
      endIndex = totalItems;
    }

    return filtered.sublist(startIndex, endIndex);
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
      final favorites = await SecureStorageManager.getFavoriteProducts();
      state = AsyncValue.data(favorites);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Hàm thêm hoặc xóa sản phẩm khỏi danh sách yêu thích
  void toggleFavorite(Vehicle vehicle) async {
    state.whenData((favoriteProducts) async {
      List<Vehicle> updatedFavorites;

      if (favoriteProducts.any((v) => v.chassisNumber == vehicle.chassisNumber)) {
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
