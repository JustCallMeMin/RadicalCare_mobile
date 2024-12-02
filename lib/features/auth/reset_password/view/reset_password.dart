import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/utils/colors.dart';
import '../../../../common/widgets/app_textfieds.dart';
import '../../../../common/widgets/button_widgets.dart';
import '../provider/reset_password_notifier.dart';

class ResetPasswordPage extends ConsumerWidget {
  final String token; // Token từ liên kết email

  ResetPasswordPage({Key? key, required this.token}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Đặt lại mật khẩu", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                const Text(
                  "Đặt lại mật khẩu",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                const Text(
                  "Vui lòng nhập mật khẩu mới và xác nhận lại.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 40.h),
                appTextField(
                  text: "Mật khẩu mới",
                  color: AppColors.secondary,
                  hintText: "Nhập mật khẩu mới",
                  obscureText: true,
                  isPasswordField: true,
                  func: (value) {
                    newPasswordController.text = value ?? "";
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mật khẩu không được để trống.";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải có ít nhất 6 ký tự.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                appTextField(
                  text: "Xác nhận mật khẩu",
                  color: AppColors.secondary,
                  hintText: "Nhập lại mật khẩu mới",
                  obscureText: true,
                  isPasswordField: true,
                  func: (value) {
                    confirmPasswordController.text = value ?? "";
                  },
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return "Mật khẩu không khớp.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                Center(
                  child: appButton(
                    buttonName: "Đặt lại mật khẩu",
                    func: () async {
                      if (_formKey.currentState!.validate()) {
                        final notifier = ref.read(resetPasswordNotifierProvider.notifier);

                        // Gọi Notifier để đặt lại mật khẩu
                        final message = await notifier.resetPassword(
                          token,
                          newPasswordController.text.trim(),
                        );

                        // Hiển thị thông báo
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message ?? "Đã xảy ra lỗi.")),
                        );

                        // Điều hướng quay lại màn hình đăng nhập nếu thành công
                        if (message == "Password reset successfully") {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/signin',
                                (route) => false,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
