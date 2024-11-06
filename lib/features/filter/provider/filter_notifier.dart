import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/model/vehicle.dart';
import '../../../common/api/filter_api.dart';
part 'filter_notifier.g.dart';

@riverpod
class FilterNotifier extends _$FilterNotifier {
  List<Vehicle> filteredVehicles = [];
  List<String> segments = [];
  List<Map<String, dynamic>> categories = [];
  List<String> colors = [];

  List<String> selectedSegments = []; // Đổi từ String thành List<String> để hỗ trợ chọn nhiều mục
  List<String> selectedColors = []; // Đổi từ String thành List<String> để hỗ trợ chọn nhiều mục
  List<int> selectedCategoryIds = []; // Đổi từ int thành List<int> để hỗ trợ chọn nhiều mục

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
      segments = await fetchSegments();
      categories = await fetchCategoriesWithId();
      colors = await fetchColors();
      state = const AsyncData(null);
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  // Cập nhật nhiều mục cho `selectedSegments`
  void toggleSegment(String segment) {
    if (selectedSegments.contains(segment)) {
      selectedSegments.remove(segment);
    } else {
      selectedSegments.add(segment);
    }
    state = AsyncData(state.value);
  }

  // Cập nhật nhiều mục cho `selectedCategoryIds`
  void toggleCategory(int categoryId) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
    } else {
      selectedCategoryIds.add(categoryId);
    }
    state = AsyncData(state.value);
  }

  // Cập nhật nhiều mục cho `selectedColors`
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
      print("Selected Segments: ${selectedSegments}");
      print("Selected Categories: ${selectedCategoryIds}");
      print("Selected Colors: ${selectedColors}");

      final response = await fetchFilteredVehicles(
        segments: selectedSegments, // List<String>
        colors: selectedColors, // List<String>
        sold: soldValue,
        categoryIds: selectedCategoryIds, // List<int>
        minCost: minPrice,
        maxCost: maxPrice,
      );

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
