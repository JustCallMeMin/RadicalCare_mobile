import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_category_notifier.g.dart';

// Notifier cho việc chọn danh mục
@riverpod
class ProductCategory extends _$ProductCategory {
  @override
  String build() {
    return "Tất cả";  // Khởi tạo giá trị là "Tất cả"
  }

  void updateCategory(String newCategory) {
    state = newCategory;  // Cập nhật danh mục mới
  }
}

// Notifier cho việc điều khiển phân trang
@riverpod
class ProductPage extends _$ProductPage {
  @override
  int build() {
    return 0;  // Trang khởi tạo là 0
  }

  void nextPage() => state++;  // Chuyển sang trang tiếp theo
  void previousPage() => state--;  // Quay lại trang trước
  void setPage(int page) => state = page;  // Đặt trang cụ thể
}
