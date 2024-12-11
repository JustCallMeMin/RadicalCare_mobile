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
  List<Vehicle> searchResults = [];
  bool showRecent = true;
  final FocusNode _focusNode = FocusNode();
  String? userId;

  @override
  void initState() {
    super.initState();
    print('initState called for SearchPage'); // Thêm log
    _searchController.text = widget.keyword;
    print('Assigned initial keyword: ${widget.keyword}'); // Thêm log
    _initializeUserId();
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Requesting focus on search bar'); // Thêm log
      _focusNode.requestFocus();
    });
  }

  Future<void> _initializeUserId() async {
    print('Initializing userId...'); // Thêm log
    try {
      final token = await SecureStorageManager.getToken();
      print('Retrieved token in _initializeUserId: $token'); // Thêm log
      if (token != null) {
        userId = TokenUtils.getUserIdFromToken(token);
        print('Extracted userId: $userId'); // Thêm log
        if (userId != null) {
          await _loadRecentSearches();
        } else {
          print('userId is null after extraction'); // Thêm log
        }
      } else {
        print('No token found in _initializeUserId'); // Thêm log
      }
    } catch (e) {
      print('Error initializing userId: $e'); // Thêm log
    }
    print('Finished _initializeUserId'); // Thêm log
  }

  Future<void> _loadRecentSearches() async {
    print('Attempting to load recent searches...'); // Thêm log
    if (userId == null) {
      print('UserId is null, skipping recent searches loading.'); // Thêm log
      return;
    }
    try {
      print('Fetching recent searches for userId: $userId'); // Thêm log
      final searches = await fetchRecentSearches(userId!);
      print('Fetched recent searches: $searches'); // Thêm log
      setState(() {
        recentSearches = searches;
      });
      print('Updated state with recent searches'); // Thêm log
    } catch (e) {
      print('Error loading recent searches: $e'); // Thêm log
    }
    print('Finished loading recent searches'); // Thêm log
  }

  Future<void> _performSearch(String keyword) async {
    print('Performing search for keyword: $keyword'); // Thêm log
    final token = await SecureStorageManager.getToken();
    print('Retrieved token in _performSearch: $token'); // Thêm log
    if (token == null || userId == null) {
      print('Token or userId is null, skipping search.'); // Thêm log
      return;
    }
    try {
      print('Calling fetchVehiclesByKeyword with keyword: $keyword'); // Thêm log
      final results = await fetchVehiclesByKeyword(keyword, userId!);
      print('Fetched search results count: ${results.length}'); // Thêm log
      setState(() {
        searchResults = results;
        showRecent = false;
      });
      print('Search results updated in state'); // Thêm log
    } catch (e) {
      print('Error performing search: $e'); // Thêm log
    }
    print('Finished _performSearch'); // Thêm log
  }

  Future<void> _clearAllRecentSearches() async {
    print('Clearing all recent searches...'); // Thêm log
    final token = await SecureStorageManager.getToken();
    print('Retrieved token in _clearAllRecentSearches: $token'); // Thêm log
    if (token == null) {
      print('Token is null, skipping clear all recent searches.'); // Thêm log
      return;
    }

    try {
      print('Calling clearAllRecentSearches API with token: $token'); // Thêm log
      await clearAllRecentSearches(token);
      setState(() {
        recentSearches.clear();
      });
      print('Cleared all recent searches in state'); // Thêm log
    } catch (e) {
      print('Error clearing recent searches: $e'); // Thêm log
    }
    print('Finished _clearAllRecentSearches'); // Thêm log
  }

  Future<void> _removeRecentSearch(String keyword) async {
    print('Removing recent search: $keyword'); // Thêm log
    final token = await SecureStorageManager.getToken();
    print('Retrieved token in _removeRecentSearch: $token'); // Thêm log
    if (token == null) {
      print('Token is null, skipping remove recent search.'); // Thêm log
      return;
    }

    try {
      print('Calling removeRecentSearch API with keyword: $keyword'); // Thêm log
      await removeRecentSearch(token, keyword);
      setState(() {
        recentSearches.remove(keyword);
      });
      print('Removed recent search: $keyword from state'); // Thêm log
    } catch (e) {
      print('Error removing recent search: $e'); // Thêm log
    }
    print('Finished _removeRecentSearch'); // Thêm log
  }

  @override
  void dispose() {
    print('dispose called for SearchPage'); // Thêm log
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build called for SearchPage'); // Thêm log
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
                    onPressed: () {
                      print('Back button pressed, popping SearchPage'); // Thêm log
                      Navigator.pop(context);
                    },
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
                print('Search bar tapped. Reloading recent searches...'); // Thêm log
                await _loadRecentSearches();
                setState(() {
                  showRecent = true;
                });
              },
              onClearSearch: () async {
                print('Search cleared. Reloading recent searches...'); // Thêm log
                await _loadRecentSearches();
                setState(() {
                  showRecent = true;
                });
              },
              focusNode: _focusNode,
            ),
            Expanded(
              child: showRecent
                  ? _buildRecentSearches()
                  : _buildSearchResults(ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    print('Building recent searches UI'); // Thêm log
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
                    onPressed: () {
                      print('Close button pressed for recent search: $search'); // Thêm log
                      _removeRecentSearch(search);
                    },
                  ),
                  onTap: () {
                    print('Recent search tapped: $search'); // Thêm log
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
    print('Building search results UI'); // Thêm log
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
              print('Navigating to ProductDetailPage for: ${vehicle.chassisNumber}'); // Thêm log
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
