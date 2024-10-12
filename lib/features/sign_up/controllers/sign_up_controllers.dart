import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/global_loader/global_loaders.dart';
import '../../../common/routes/app_routes_name.dart';
import '../provider/register_notifier.dart';
import '../repo/sign_up_repo.dart';

class SignUpController {
  late WidgetRef ref;

  SignUpController({required this.ref});

  Future<void> handleSignUp(BuildContext context) async {
    var state = ref.read(registerNotifierProvider);
    String userName = state.userName.trim();
    String email = state.email.trim();
    String password = state.password;
    String confirmPassword = state.confirmPassword;

    // Nếu không hợp lệ, dừng lại và không thực hiện đăng ký.
    if (validateUserName(userName) != null ||
        validateEmail(email) != null ||
        validatePassword(password) != null || // Chỉ truyền vào mật khẩu
        validateConfirmPassword(password, confirmPassword) != null) {
      // Gọi phương thức riêng cho xác nhận mật khẩu
      return;
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(true);

    try {
      final credential = await SignUpRepo.firebaseSignUp(email, password);
      if (kDebugMode) {
        print(credential);
      }
      if (credential.user != null) {
        await credential.user?.sendEmailVerification();
        await credential.user?.updateDisplayName(userName);
        Navigator.pushReplacementNamed(context, AppRoutesNames.SIGN_UP);
        // Có thể thêm logic để thông báo cho người dùng về việc gửi email xác minh tại đây nếu cần.
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      ref.read(appLoaderProvider.notifier).setLoaderValue(false);
    }
  }

  String? validateUserName(String userName) {
    if (userName.isEmpty) {
      return 'Username của bạn đang trống';
    }
    if (userName.length < 6) {
      return 'Username của bạn chưa đủ 6 ký tự';
    }
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email của bạn đang trống';
    }
    const emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return 'Vui lòng điền đúng email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Mật khẩu của bạn đang trống';
    }
    if (password.length < 6) {
      return 'Mật khẩu của bạn chưa đủ 6 ký tự';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Xác nhận mật khẩu của bạn đang trống';
    }
    if (password != confirmPassword) {
      return 'Mật khẩu và xác nhận mật khẩu không khớp';
    }
    return null;
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      // Xử lý lỗi mật khẩu yếu (nếu cần thiết).
    } else if (e.code == 'email-already-in-use') {
      // Xử lý lỗi email đã được sử dụng (nếu cần thiết).
    } else if (e.code == 'user-not-found') {
      // Xử lý lỗi không tìm thấy tài khoản người dùng (nếu cần thiết).
    } else {
      // Xử lý các lỗi khác (nếu cần thiết).
    }
  }
}
