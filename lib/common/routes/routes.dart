import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radicalcare/features/sign_in/view/sign_in.dart';
import 'package:radicalcare/features/sign_up/view/sign_up.dart';

import '../../features/application/view/application.dart';
import '../../features/home/view/home.dart';
import '../../features/welcome/welcome.dart';
import 'app_routes_name.dart';

class AppPages {
  // Danh sách các route của ứng dụng
  static List<RouteEntity> routes() {
    return [
      RouteEntity(
        path: AppRoutesNames.WELCOME,
        page: Welcome(),
      ),
      RouteEntity(
        path: AppRoutesNames.SIGN_IN,
        page: const SignIn(),
      ),
      RouteEntity(
        path: AppRoutesNames.SIGN_UP,
        page: const SignUp(),
      ),
      RouteEntity(
        path: AppRoutesNames.APPLICATION,
        page: const Application(),
      ),
      RouteEntity(
        path: AppRoutesNames.HOME ,
        page: const Home(),
      ),
    ];
  }

  // Phương thức để generate routes cho Navigator
  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
    if (kDebugMode) {
      print('Navigating to ${settings.name}');
    }

    switch (settings.name) {
      case AppRoutesNames.WELCOME:
        return MaterialPageRoute(
          builder: (_) => Welcome(),
          settings: settings,
        );
      case AppRoutesNames.SIGN_IN:
        return MaterialPageRoute(
          builder: (_) => const SignIn(),
          settings: settings,
        );
      case AppRoutesNames.SIGN_UP:
        return MaterialPageRoute(
          builder: (_) => const SignUp(),
          settings: settings,
        );
      case AppRoutesNames.APPLICATION:
        return MaterialPageRoute(
          builder: (_) => const Application(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Welcome(),
          settings: settings,
        );
    }
  }
}

// Lớp RouteEntity giúp quản lý thông tin về mỗi route.
class RouteEntity {
  final String path;
  final Widget page;

  RouteEntity({required this.path, required this.page});
}
