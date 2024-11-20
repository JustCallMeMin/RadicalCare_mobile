import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radicalcare/features/favorite/view/favorite.dart';
import 'package:radicalcare/features/sign_in/view/sign_in.dart';
import 'package:radicalcare/features/sign_up/view/sign_up.dart';

import '../../features/application/view/application.dart';
import '../../features/filter/view/filter.dart';
import '../../features/home/view/home.dart';
import '../../features/welcome/welcome.dart';
import '../model/vehicle.dart';
import 'app_routes_name.dart';

import 'package:radicalcare/features/product_detail/view/product_detail.dart'; // Import trang ProductDetailPage

class AppPages {
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
        path: AppRoutesNames.HOME,
        page: const HomePage(),
      ),
      RouteEntity(
        path: AppRoutesNames.PRODUCT_DETAIL,
        page: FilterScreen(),
      ),
      RouteEntity(
        path: AppRoutesNames.FAVOR,
        page: const FavoriteScreen(),
      ),
    ];
  }

  static MaterialPageRoute generateRouteSettings(RouteSettings settings) {
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
      case AppRoutesNames.HOME:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case AppRoutesNames.PRODUCT_DETAIL:
        final arguments = settings.arguments;
        if (arguments is Vehicle) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailPage(productId: arguments.chassisNumber),
            settings: settings,
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid arguments for ProductDetailPage')),
            ),
          );
        }
      case AppRoutesNames.FILTER:
        return MaterialPageRoute(
          builder: (_) => FilterScreen(),
          settings: settings,
        );
      case AppRoutesNames.FAVOR:
        return MaterialPageRoute(
          builder: (_) => const FavoriteScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Application(),
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
