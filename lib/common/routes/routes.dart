import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radicalcare/features/auth/forgot_password/view/forgot_pasword.dart';
import 'package:radicalcare/features/auth/reset_password/view/reset_password.dart';

import '../../features/application/view/application.dart';
import '../../features/appointment/appointment_detail/appointment_detail.dart';
import '../../features/appointment/appointment_list/view/appointment_list.dart';
import '../../features/auth/sign_in/view/sign_in.dart';
import '../../features/auth/sign_up/view/sign_up.dart';
import '../../features/auth/update_profile/view/update_profile.dart';
import '../../features/cart/view/cart.dart';
import '../../features/product/filter/view/filter.dart';
import '../../features/home/booking/view/booking.dart';
import '../../features/home/home_page/view/home.dart';
import '../../features/product/product_detail/view/product_detail.dart';
import '../../features/profile/view/profile.dart';
import '../../features/welcome/welcome.dart';
import '../model/appointment_model.dart';
import '../model/vehicle_model.dart';
import 'app_routes_name.dart';

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
        path: AppRoutesNames.PROFILE,
        page: const ProfilePage(),
      ),
      RouteEntity(
        path: AppRoutesNames.FILTER,
        page: FilterScreen(),
      ),
      RouteEntity(
        path: AppRoutesNames.PRODUCT_DETAIL,
        page: const ProductDetailPage(productId: ""), // Mặc định sản phẩm rỗng
      ),
      RouteEntity(
        path: AppRoutesNames.FORGOT_PASSWORD,
        page: const ForgotPasswordPage(),
      ),
      RouteEntity(
        path: AppRoutesNames.BOOKING,
        page: const BookingPage(),
      ),
      RouteEntity(
        path: AppRoutesNames.UPDATE_PROFILE,
        page: UpdateProfilePage(),
      ),
      RouteEntity(
        path: AppRoutesNames.APPOINTMENT_LIST, // Thêm route mới
        page: const AppointmentListPage(),
      ),
      RouteEntity(
        path: AppRoutesNames.APPOINTMENT_DETAILS,
        page: const Placeholder(), // Thay Placeholder bằng trang chi tiết phiếu
      ),
      RouteEntity(
        path: AppRoutesNames.CART,
        page: CartPage(), // Thêm trang Cart
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
      case AppRoutesNames.FILTER:
        return MaterialPageRoute(
          builder: (_) => FilterScreen(),
          settings: settings,
        );
      case AppRoutesNames.PROFILE:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case AppRoutesNames.FORGOT_PASSWORD:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );
      case AppRoutesNames.RESET_PASSWORD:
        final token = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordPage(token: token),
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
              body: Center(
                child: Text('Invalid arguments for ProductDetailPage'),
              ),
            ),
          );
        }
      case AppRoutesNames.BOOKING:
        return MaterialPageRoute(
          builder: (_) => const BookingPage(),
          settings: settings,
        );
      case AppRoutesNames.UPDATE_PROFILE:
        return MaterialPageRoute(
          builder: (_) => UpdateProfilePage(),
          settings: settings,
        );
      case AppRoutesNames.APPOINTMENT_LIST:
        return MaterialPageRoute(
          builder: (_) => const AppointmentListPage(), // Thêm route cho AppointmentList
          settings: settings,
        );
      case AppRoutesNames.APPOINTMENT_DETAILS:
        final appointment = settings.arguments as Appointment;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailsPage(appointment: appointment),
          settings: settings,
        );
      case AppRoutesNames.CART:
        return MaterialPageRoute(
          builder: (_) => CartPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Application(),
          settings: settings,
        );
    }
  }
}

// Lớp RouteEntity giúp quản lý thông tin về mỗi route
class RouteEntity {
  final String path;
  final Widget page;

  RouteEntity({required this.path, required this.page});
}
