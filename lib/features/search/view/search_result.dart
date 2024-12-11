import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/model/vehicle.dart';
import 'package:radicalcare/features/product/view/widgets/product_widgets.dart';
import 'package:radicalcare/features/search/view/widgets/search_widget.dart';
import '../../product/provider/product_notifier.dart';
import '../provider/search_notifier.dart';

class SearchResultsPage extends ConsumerWidget {
  final String keyword;
  const SearchResultsPage({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchNotifierProvider(keyword));

    return Scaffold(
      appBar: AppBar(title: Text("Kết quả tìm kiếm cho: $keyword")),
      body: searchResults.when(
        data: (products) {
          // Sử dụng widget riêng, không phụ thuộc logic phân trang cũ
          return searchResultsGrid(products);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
