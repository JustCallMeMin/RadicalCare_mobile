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

  Future<String> _determineInitialRoute() async {
    final isFirstTime = await SecureStorageManager.readData('isFirstTime');
    final authToken = await SecureStorageManager.getToken();

    // Kiểm tra nếu lần đầu mở app
    if (isFirstTime == null) {
      await SecureStorageManager.saveData('isFirstTime', 'false');
      return AppRoutesNames.WELCOME;
    }

    // Nếu có token hợp lệ
    if (authToken != null && authToken.isNotEmpty) {
      return AppRoutesNames.APPLICATION;
    }

    // Nếu không có token
    return AppRoutesNames.SIGN_IN;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.appThemeData,
        title: 'RadicalCare',
        onGenerateRoute: AppPages.generateRouteSettings,
        home: FutureBuilder<String>(
          future: _determineInitialRoute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Error occurred while initializing the app.'),
                ),
              );
            }

            final initialRoute = snapshot.data;
            if (initialRoute != null) {
              return MaterialApp(
                initialRoute: initialRoute,
                onGenerateRoute: AppPages.generateRouteSettings,
              );
            }

            return const Scaffold(
              body: Center(
                child: Text('Failed to determine initial route.'),
              ),
            );
          },
        ),
      ),
    );
  }
}
