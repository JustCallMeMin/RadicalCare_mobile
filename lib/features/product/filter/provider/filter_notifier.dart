import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/model/vehicle_model.dart';
import '../../../../common/api/filter_api.dart';
import '../../../../common/utils/secure_storage.dart';
part 'filter_notifier.g.dart';

@riverpod
class FilterNotifier extends _$FilterNotifier {
  List<Vehicle> filteredVehicles = [];
  List<String> segments = [];
  List<Map<String, dynamic>> categories = [];
  List<String> colors = [];

  List<String> selectedSegments = [];
  List<String> selectedColors = [];
  List<int> selectedCategoryIds = [];

  bool? soldValue = null;
  double minPrice = 0;
  double maxPrice = 40000000;

  @override
  Future<List<Vehicle>?> build() async {
    await _loadFilterOptions();
    return null;
  }

  Future<void> _loadFilterOptions() async {
    state = const AsyncLoading();
    try {
      final token = await SecureStorageManager.getToken(); // Lấy token từ storage
      if (token == null) {
        throw Exception("User not logged in.");
      }

      // Gọi API để lấy các tùy chọn bộ lọc
      segments = await fetchSegments(token);
      categories = await fetchCategoriesWithId(token);
      colors = await fetchColors(token);

      state = const AsyncData(null);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  void toggleSegment(String segment) {
    if (selectedSegments.contains(segment)) {
      selectedSegments.remove(segment);
    } else {
      selectedSegments.add(segment);
    }
    state = AsyncData(state.value);
  }

  void toggleCategory(int categoryId) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
    } else {
      selectedCategoryIds.add(categoryId);
    }
    state = AsyncData(state.value);
  }

  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
    state = AsyncData(state.value);
  }

  void selectSoldStatus(bool? sold) {
    soldValue = sold;
    state = AsyncData(state.value);
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    state = AsyncData(state.value);
  }

  Future<void> applyFilters() async {
    state = const AsyncLoading();
    try {
      final token = await SecureStorageManager.getToken(); // Lấy token từ storage
      if (token == null) {
        throw Exception("User not logged in.");
      }

      // Gọi API áp dụng bộ lọc
      final response = await fetchFilteredVehicles(
        token: token,
        segments: selectedSegments,
        colors: selectedColors,
        sold: soldValue,
        categoryIds: selectedCategoryIds,
        minCost: minPrice,
        maxCost: maxPrice,
      );

      // Chuyển đổi kết quả thành danh sách Vehicle
      filteredVehicles = response.map((json) => Vehicle.fromJson(json)).toList();
      print("Filtered Vehicles: ${filteredVehicles.length}");
      state = AsyncData(filteredVehicles);
    } catch (error) {
      print("Filter Error: $error");
      state = AsyncError(error, StackTrace.current);
    }
  }

  void resetFilters() {
    selectedSegments.clear();
    selectedColors.clear();
    selectedCategoryIds.clear();
    soldValue = null;
    minPrice = 0;
    maxPrice = 40000000;
    filteredVehicles = [];
    state = const AsyncData(null);
  }
}