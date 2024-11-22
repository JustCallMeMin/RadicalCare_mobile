import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/features/search/view/search_result.dart';
import 'package:radicalcare/features/search/view/widgets/search_widget.dart';
import '../../../common/model/vehicle.dart';
import '../../../common/utils/colors.dart';
import '../../../common/utils/secure_storage.dart';
import '../../../common/widgets/text_widgets.dart';
import '../../../common/api/search_api.dart';
import '../../../common/utils/token_utils.dart';
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
  List<Vehicle> searchResults = []; // Kết quả tìm kiếm
  bool showRecent = true; // Hiển thị RecentSearch mặc định
  final FocusNode _focusNode = FocusNode();
  String? userId; // Lưu trữ userId từ token

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword; // Gán từ khóa ban đầu
    _initializeUserId(); // Trích xuất userId từ JWT
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _initializeUserId() async {
    try {
      print('Initializing userId...');
      final token = await SecureStorageManager.getToken(); // Lấy JWT từ SecureStorage
      print('Retrieved token: $token');
      if (token != null) {
        userId = TokenUtils.getUserIdFromToken(token); // Trích xuất userId từ JWT
        print('Extracted userId: $userId');
        if (userId != null) {
          await _loadRecentSearches(); // Load danh sách tìm kiếm gần đây
        }
      } else {
        print('No token found.');
      }
    } catch (e) {
      print('Error initializing userId: $e');
    }
  }

  Future<void> _loadRecentSearches() async {
    if (userId == null) {
      print('UserId is null, skipping recent searches loading.');
      return;
    }
    try {
      print('Fetching recent searches for userId: $userId');
      final searches = await fetchRecentSearches(userId!); // Gọi API lấy recent searches
      print('Fetched recent searches: $searches'); // Kiểm tra dữ liệu trả về
      setState(() {
        recentSearches = searches;
      });
    } catch (e) {
      print('Error loading recent searches: $e');
    }
  }

  Future<void> _performSearch(String keyword) async {
    final token = await SecureStorageManager.getToken(); // Lấy token từ SecureStorage
    if (token == null || userId == null) {
      print('Token or userId is null, skipping search.');
      return;
    }
    try {
      final results = await fetchVehiclesByKeyword(token, keyword); // Gọi API tìm kiếm
      setState(() {
        searchResults = results; // Lưu kết quả tìm kiếm
        showRecent = false; // Chuyển sang hiển thị kết quả tìm kiếm
      });
      print('Search results fetched successfully.');
    } catch (e) {
      print('Error performing search: $e');
    }
  }

  Future<void> _clearAllRecentSearches() async {
    final token = await SecureStorageManager.getToken(); // Lấy token từ SecureStorage
    if (token == null) {
      print('Token is null, skipping clear all recent searches.');
      return;
    }

    try {
      print('Clearing all recent searches with token: $token');
      await clearAllRecentSearches(token); // Gọi API để xóa tất cả
      setState(() {
        recentSearches.clear();
      });
      print('Cleared all recent searches.');
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }

  Future<void> _removeRecentSearch(String keyword) async {
    final token = await SecureStorageManager.getToken(); // Lấy token từ SecureStorage
    if (token == null) {
      print('Token is null, skipping remove recent search.');
      return;
    }

    try {
      print('Removing recent search for keyword: $keyword with token: $token');
      await removeRecentSearch(token, keyword); // Gọi API để xóa một mục
      setState(() {
        recentSearches.remove(keyword);
      });
      print('Removed recent search: $keyword');
    } catch (e) {
      print('Error removing recent search: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
                      Icons.arrow_back_ios,
                      color: AppColors.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            searchBarOnSearchPage(
              context: context,
              ref: ref,
              searchController: _searchController,
              onSearch: _performSearch,
              onTapSearchBar: () async {
                print('Search bar tapped.');
                await _loadRecentSearches();
                setState(() {
                  showRecent = true;
                });
              },
              onClearSearch: () async {
                print('Search cleared.');
                await _loadRecentSearches();
                setState(() {
                  showRecent = true;
                });
              },
              focusNode: _focusNode,
            ),
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
    print('Building recent searches UI.');
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
          Expanded(
            child: ListView.separated(
              itemCount: recentSearches.length,
              separatorBuilder: (context, index) => Divider(
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
                    print('Recent search tapped: $search');
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
    print('Building search results UI.');
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
        Expanded(
          child: productListResult(
            searchResults: searchResults,
            onItemTap: (vehicle) {
              print('Navigating to ProductDetailPage for: ${vehicle.chassisNumber}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailPage(productId: vehicle.chassisNumber),
                ),
              );
            },
            ref: ref,
          ),
        ),
      ],
    );
  }
}
