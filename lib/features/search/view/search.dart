import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/features/search/view/widgets/search_widget.dart';
import '../../../common/utils/colors.dart';
import '../../../common/widgets/text_widgets.dart'; // Widgets liên quan
import '../../product/provider/product_notifier.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key, required this.keyword});
  final String keyword;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<String> categories = [];
  bool isLoadingCategories = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Centered text "Tìm Kiếm"
                  Center(
                    child: text28Bold(
                      text: "Tìm Kiếm",
                      color: AppColors.secondary,
                    ),
                  ),
                  // Left-aligned back arrow button
                  Positioned(
                    left: 0,
                    child: IconButton(
                      padding: EdgeInsets.zero, // Xóa padding của IconButton để sát lề trái
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              // Search bar widget
              searchBar(context, ref, _searchController),
            ],
          ),
        ),
      ),
    );
  }
}
