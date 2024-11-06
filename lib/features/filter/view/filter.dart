import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/features/filter/view/widgets/filter_widgets.dart';
import '../../filtered_product/view/filtered_product.dart';
import '../provider/filter_notifier.dart';

class FilterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.watch(filterNotifierProvider.notifier);
    final filterState = ref.watch(filterNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bộ lọc"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filterState.when(
          data: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Phân khúc'),
              buildChoiceChips(
                options: filterNotifier.segments,
                selectedOptions: filterNotifier.selectedSegments,
                onSelected: (value) {
                  filterNotifier.toggleSegment(value); // Cập nhật phân khúc với lựa chọn nhiều mục
                },
              ),
              buildSectionTitle('Loại xe'),
              buildChoiceChips(
                options: filterNotifier.categories
                    .map((category) => category['name'] as String)
                    .toList(),
                selectedOptions: filterNotifier.selectedCategoryIds
                    .map((id) => filterNotifier.categories
                    .firstWhere((category) => category['id'] == id)['name'] as String)
                    .toList(),
                onSelected: (value) {
                  final selectedCategory = filterNotifier.categories.firstWhere(
                        (category) => category['name'] == value,
                  );
                  filterNotifier.toggleCategory(selectedCategory['id']);
                },
              ),
              buildSectionTitle('Màu sắc'),
              buildChoiceChips(
                options: filterNotifier.colors,
                selectedOptions: filterNotifier.selectedColors,
                onSelected: (value) {
                  filterNotifier.toggleColor(value);
                },
              ),
              buildSectionTitle('Tình trạng bán'),
              buildSoldFilter(
                soldValue: filterNotifier.soldValue,
                onChanged: (value) {
                  filterNotifier.selectSoldStatus(value);
                },
              ),
              buildSectionTitle('Phạm vi giá'),
              buildPriceRange(
                minPrice: filterNotifier.minPrice,
                maxPrice: filterNotifier.maxPrice,
                onChanged: (RangeValues values) {
                  filterNotifier.setPriceRange(values.start, values.end);
                },
              ),
              const Spacer(),
              buildBottomButtons(
                onReset: () {
                  filterNotifier.resetFilters();
                },
                onApply: () async {
                  await filterNotifier.applyFilters();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilteredProductScreen()),
                  );
                },
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
