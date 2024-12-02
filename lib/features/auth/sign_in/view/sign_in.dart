import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/auth/sign_in/view/widgets/sign_in_widgets.dart';

import '../../../../common/routes/app_routes_name.dart';
import '../../../../common/utils/secure_storage.dart';
import '../../../../common/widgets/app_divider.dart';
import '../../../../common/widgets/app_textfieds.dart';
import '../provider/sign_in_notifier.dart';



class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  bool isPasswordVisible = false; // Điều khiển hiển thị mật khẩu
  final _formKey = GlobalKey<FormState>(); // Khóa để xác thực biểu mẫu

  @override
  Widget build(BuildContext context) {
    final signInNotifier =
    ref.watch(signInNotifierProvider); // Lắng nghe trạng thái
    final isLoading = signInNotifier.isLoading; // Trạng thái tải

    return Container(
      color: AppColors.primaryBg,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryBg,
          body: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              color: AppColors.primary,
            ),
          )
              : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w),
                      child: text32Bold(text: "Đăng nhập tài khoản"),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 25.w),
                      child:
                      text14Normal(text: "Rất vui được gặp lại bạn"),
                    ),
                  ),
                  SizedBox(height: 38.h),
                  // Email TextField
                  appTextField(
                    text: "Username",
                    color: AppColors.secondary,
                    hintText: "Nhập username của bạn",
                    isPasswordField: false,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    func: (value) {
                      ref
                          .read(signInNotifierProvider.notifier)
                          .onUsernameChange(value);
                    },
                    validator: (value) => ref
                        .read(signInNotifierProvider.notifier)
                        .validateUsername(value ?? ""),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Password TextField
                  appTextField(
                    text: "Mật khẩu",
                    color: AppColors.secondary,
                    hintText: "Nhập mật khẩu của bạn",
                    obscureText: !isPasswordVisible,
                    isPasswordField: true,
                    iconName: isPasswordVisible
                        ? AppImages.eyeClose
                        : AppImages.eye,
                    onIconTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    func: (value) {
                      ref
                          .read(signInNotifierProvider.notifier)
                          .onUserPasswordChange(value);
                    },
                    validator: (value) => ref
                        .read(signInNotifierProvider.notifier)
                        .validatePassword(value ?? ""),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25.w),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutesNames.FORGOT_PASSWORD);
                      },
                      child: textUnderline(
                        text: "Quên mật khẩu?",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  Center(
                    child: appButton(
                      buttonName: "Đăng nhập",
                      func: () async {
                        if (_formKey.currentState!.validate()) {
                          final token = await ref.read(signInNotifierProvider.notifier).signInUser();
                          if (token != null) {
                            // Lưu token vào SecureStorage
                            await SecureStorageManager.saveToken(token);

                            // Điều hướng đến Application
                            Navigator.pushReplacementNamed(context, AppRoutesNames.APPLICATION);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đăng nhập thất bại, vui lòng thử lại.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  appDivider(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: appThirdPartyButton(
                      buttonName: "Đăng nhập bằng Google",
                      iconPath: AppImages.google,
                      buttonColor: Colors.white,
                      textColor: Colors.black,
                      isOutlined: true,
                      onTap: () {
                        // Xử lý đăng nhập với Google
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: appThirdPartyButton(
                      buttonName: "Đăng nhập bằng Facebook",
                      iconPath: AppImages.facebook,
                      buttonColor: Colors.blue,
                      textColor: Colors.white,
                      isOutlined: true,
                      onTap: () {
                        // Xử lý đăng nhập với Facebook
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  registerPrompt(
                    context: context,
                    func: () {
                      Navigator.pushNamed(
                          context, AppRoutesNames.SIGN_UP);
                    },
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
