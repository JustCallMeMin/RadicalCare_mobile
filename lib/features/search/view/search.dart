import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/features/search/view/widgets/search_widget.dart';
import '../../../common/model/vehicle.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widgets/text_widgets.dart';
import '../../../common/api/search_api.dart';
import '../../product_detail/view/product_detail.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, required this.keyword});
  final String keyword;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];
  List<dynamic> searchResults = []; // Kết quả tìm kiếm
  bool showRecent = true; // Hiển thị RecentSearch mặc định
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword; // Gán từ khóa ban đầu
    _loadRecentSearches(); // Load danh sách tìm kiếm gần đây
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadRecentSearches() async {
    try {
      final searches = await fetchRecentSearches(); // Gọi API lấy recent searches
      setState(() {
        recentSearches = searches;
      });
    } catch (e) {
      print('Error loading recent searches: $e'); // Debug lỗi
    }
  }


  Future<void> _performSearch(String keyword) async {
    try {
      final results = await fetchVehiclesByKeyword(keyword); // Gọi API tìm kiếm
      setState(() {
        searchResults = results; // Lưu kết quả tìm kiếm
        showRecent = false; // Chuyển sang hiển thị kết quả tìm kiếm
      });
    } catch (e) {
      print('Error performing search: $e');
    }
  }

  Future<void> _clearAllRecentSearches() async {
    try {
      await clearAllRecentSearches(); // Gọi API để xóa tất cả
      setState(() {
        recentSearches.clear();
      });
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }

  Future<void> _removeRecentSearch(String keyword) async {
    try {
      await removeRecentSearch(keyword); // Gọi API để xóa một mục
      setState(() {
        recentSearches.remove(keyword);
      });
    } catch (e) {
      print('Error removing recent search: $e');
    }
  }
  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose(); // Hủy FocusNode
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: text28Bold(
                    text: "Tìm Kiếm",
                    color: AppColors.secondary,
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                        Icons.arrow_back_ios, color: AppColors.primary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            searchBarOnSearchPage(
              context: context,
              ref: ref,
              searchController: _searchController,
              onSearch: _performSearch, // Hàm thực hiện tìm kiếm
              onTapSearchBar: () async {
                await _loadRecentSearches(); // Fetch recent searches khi nhấn vào thanh tìm kiếm
                setState(() {
                  showRecent = true; // Hiển thị recentSearch
                });
              },
              onClearSearch: () async {
                await _loadRecentSearches(); // Fetch lại recent searches khi xóa hết nội dung
                setState(() {
                  showRecent = true; // Hiển thị lại recentSearch
                });
              },
              focusNode: _focusNode, // FocusNode để giữ focus
            ),
            // Dùng Expanded để tránh lỗi bố cục
            Expanded(
              child: showRecent
                  ? _buildRecentSearches() // Hiển thị recent searches
                  : _buildSearchResults(ref), // Hiển thị kết quả tìm kiếm
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gần đây',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _clearAllRecentSearches,
                child: Text(
                  'Xóa tất cả',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Divider(height: 16.h, thickness: 1, color: Colors.grey.shade300),
          Expanded( // Bao bọc ListView trong Expanded
            child: ListView.separated(
              itemCount: recentSearches.length,
              separatorBuilder: (context, index) =>
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
              itemBuilder: (context, index) {
                final search = recentSearches[index];
                return ListTile(
                  title: Text(search),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => _removeRecentSearch(search),
                  ),
                  onTap: () {
                    _performSearch(search);
                    _searchController.text = search;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kết quả cho "${_searchController.text}"',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '${searchResults.length} được tìm thấy',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded( // Bọc GridView trong Expanded để tránh lỗi
          child: productListResult(
            searchResults: searchResults.cast<Vehicle>(), // Ép kiểu
            onItemTap: (vehicle) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailPage(productId: vehicle.chassisNumber),
                ),
              );
            },
            ref: ref, // Truyền ref vào đây
          ),
        ),
      ],
    );
  }
}
