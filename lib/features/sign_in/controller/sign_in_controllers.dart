import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/common/global_loader/global_loaders.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import '../../../common/routes/app_routes_name.dart';
import '../provider/sign_in_notifier.dart';
import '../repo/sign_in_repo.dart';

class SignInController {
  late WidgetRef ref;

  SignInController(this.ref);

  Future<void> handleSignIn(BuildContext context) async {
    var state = ref.read(signInNotifierProvider);
    String email = state.email.trim();
    String password = state.password;

    // Nếu không hợp lệ, dừng lại và không thực hiện đăng nhập.
    if (validateEmail(email) != null || validatePassword(password) != null) {
      return;
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(true);

    try {
      final credential = await SignInRepo.firebaseSignIn(email, password);
      if (kDebugMode) {
        print(credential);
      }
      if (credential.user != null) {
        // Kiểm tra xem email của người dùng đã được xác minh chưa.
        if (credential.user!.emailVerified) {
          Navigator.pushReplacementNamed(context, AppRoutesNames.APPLICATION);
        } else {
          await credential.user!.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: text16Normal(text: 'Email của bạn chưa được xác minh. Vui lòng kiểm tra hộp thư và xác minh email.'),
            ),
          );
        }
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

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    if (e.code == 'wrong-password') {
      // Xử lý lỗi mật khẩu sai (nếu cần thiết).
    } else if (e.code == 'user-not-found') {
      // Xử lý lỗi không tìm thấy tài khoản người dùng (nếu cần thiết).
    } else {
      // Xử lý các lỗi khác (nếu cần thiết).
    }
  }
}
