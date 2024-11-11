import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/model/vehicle.dart';
import 'package:radicalcare/features/product/view/widgets/product_widgets.dart';
import '../../product/provider/product_notifier.dart';
import '../provider/search_notifier.dart';

class SearchResultsPage extends ConsumerWidget {
  final String keyword;
  const SearchResultsPage({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy kết quả tìm kiếm từ SearchNotifier
    final searchResults = ref.watch(searchNotifierProvider(keyword));

    return Scaffold(
      appBar: AppBar(title: Text("Kết quả tìm kiếm cho: $keyword")),
      body: searchResults.when(
        data: (products) {
          // Kiểm tra nếu danh sách sản phẩm trống
          return productList(
            currentPage: 0, // Giả sử hiển thị trang đầu tiên
            selectedCategory: "Tất cả", // Không cần thiết cho trang tìm kiếm
            onPageChange: (int newPage) {},
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
