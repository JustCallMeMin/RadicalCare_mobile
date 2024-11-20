import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/product/view/widgets/product_widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../common/api/product_api.dart';
import '../../../common/model/category.dart';
import '../../../common/utils/colors.dart';
import '../provider/product_notifier.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Category> categories = [];
  bool isLoadingCategories = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    _initializeNotificationPlugin();
    _loadCategories();
  }

  // Khởi tạo plugin thông báo
  void _initializeNotificationPlugin() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Yêu cầu quyền thông báo
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.notification.isGranted) {
      _initializeNotificationPlugin();
    }
  }

  // Gọi API để tải danh mục
  Future<void> _loadCategories() async {
    try {
      final response = await fetchCategories(); // Gọi hàm fetchCategories()
      if (response["success"] == true) {
        // Lấy danh sách dữ liệu từ "data"
        final List<dynamic> data = response["data"];
        // Chuyển đổi từng phần tử thành đối tượng Category
        final List<Category> fetchedCategories =
        data.map((json) => Category.fromJson(json)).toList();

        setState(() {
          categories = fetchedCategories; // Gán danh sách danh mục đầy đủ
          isLoadingCategories = false;
        });
      } else {
        throw Exception(response["message"] ?? "Failed to fetch categories.");
      }
    } catch (e) {
      debugPrint("Failed to load categories: $e");
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  // Hiển thị thông báo
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Sản phẩm mới!',
      'Khám phá sản phẩm mới ngay!',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(
        productCategoryProvider); // Lấy selectedCategory từ ProductCategoryNotifier
    final currentPage = ref
        .watch(productPageProvider); // Lấy currentPage từ ProductPageNotifier

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text28Bold(text: "Khám Phá", color: AppColors.secondary),
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: AppColors.secondary,
                        size: 24.sp,
                      ),
                      onPressed:
                      showNotification, // Nhấn vào biểu tượng thông báo
                    ),
                  ],
                ),
              ),
              searchBar(context, ref, _searchController),
              if (isLoadingCategories)
                const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    color: AppColors.primary,
                  ),
                ) // Hiển thị khi đang load danh mục
              else
                categoryFilter(
                  categories: categories.map((c) => c.name).toList(),
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    ref.read(productCategoryProvider.notifier).updateCategory(category); // Cập nhật danh mục
                    ref.read(productNotifierProvider.notifier).filterByCategory(category); // Lọc sản phẩm
                    ref.read(productPageProvider.notifier).setPage(0); // Reset lại trang
                  },
                ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: text24Normal(text: selectedCategory),
              ),
              productList(
                currentPage: currentPage,
                selectedCategory: selectedCategory,
                onPageChange: (newPage) {
                  ref.read(productPageProvider.notifier).setPage(newPage); // Cập nhật trang mới
                },
                ref: ref, // Truyền WidgetRef
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
