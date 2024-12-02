import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/widgets/app_divider.dart';
import 'package:radicalcare/common/widgets/app_textfieds.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import '../../../../common/routes/app_routes_name.dart';
import '../../../../common/widgets/text_widgets.dart';
import '../provider/forgot_password_notifier.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordNotifierProvider);
    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);

    return Container(
      color: AppColors.primaryBg,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryBg,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w),
                      child: const Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w),
                      child: const Text(
                        "Vui lòng nhập email để nhận liên kết đặt lại mật khẩu.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 38.h),
                  // Email TextField
                  appTextField(
                    text: "Email",
                    color: AppColors.secondary,
                    hintText: "Nhập email của bạn",
                    isPasswordField: false,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    func: notifier.updateEmail,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email không được để trống.";
                      }
                      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                      if (!emailRegex.hasMatch(value)) {
                        return "Email không hợp lệ.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25.w),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutesNames.SIGN_IN);
                      },
                      child: textUnderline(
                        text: "Quay lại?",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 84.h,
                  ),
                  Center(
                    child: appButton(
                      buttonName: "Gửi liên kết đặt lại mật khẩu",
                      func: () async {
                        if (_formKey.currentState!.validate()) {
                          final message = await notifier.sendForgotPassword();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
