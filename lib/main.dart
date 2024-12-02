import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/routes/app_routes_name.dart';
import 'package:radicalcare/common/routes/routes.dart';
import 'package:radicalcare/common/utils/app_styles.dart';
import 'package:radicalcare/common/utils/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.appThemeData,
        title: 'RadicalCare',
        home: FutureBuilder<String>(
          future: _determineInitialRoute(),
          builder: (context, snapshot) {
            // Hiển thị khi chờ xác định route ban đầu
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Xử lý khi có lỗi trong Future
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    'Error occurred while initializing the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // Xác định route ban đầu
            final initialRoute = snapshot.data ?? AppRoutesNames.SIGN_IN;

            return MaterialApp(
              theme: AppTheme.appThemeData,
              initialRoute: initialRoute,
              onGenerateRoute: AppPages.generateRouteSettings,
            );
          },
        ),
      ),
    );
  }

  Future<String> _determineInitialRoute() async {
    try {
      final isFirstTime = await SecureStorageManager.readData('isFirstTime');
      final authToken = await SecureStorageManager.getToken();

      // Kiểm tra lần đầu mở ứng dụng
      if (isFirstTime == null) {
        await SecureStorageManager.saveData('isFirstTime', 'false');
        return AppRoutesNames.WELCOME;
      }

      // Kiểm tra trạng thái đăng nhập
      if (authToken != null && authToken.isNotEmpty) {
        return AppRoutesNames.APPLICATION;
      }

      // Mặc định trả về SIGN_IN
      return AppRoutesNames.SIGN_IN;
    } catch (e) {
      print('Error in _determineInitialRoute: $e');
      return AppRoutesNames.SIGN_IN; // Trả về SIGN_IN nếu xảy ra lỗi
    }
  }
}
