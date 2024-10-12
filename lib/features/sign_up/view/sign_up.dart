import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/global_loader/global_loaders.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/app_divider.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/sign_up/controllers/sign_up_controllers.dart';
import 'package:radicalcare/features/sign_up/view/widgets/sign_up_widgets.dart';

import '../../../common/widgets/app_textfieds.dart';
import '../provider/register_notifier.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  late SignUpController _controller;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = SignUpController(ref: ref);
    super.initState();
  }

  Widget build(BuildContext context) {
    final regProvider = ref.watch(registerNotifierProvider);
    final loader = ref.watch(appLoaderProvider);

    return Container(
      color: AppColors.primaryBg,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryBg,
          body: loader == false
              ? SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35.h,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: text32Bold(text: "Tạo tài khoản"),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: text14Normal(
                                text: "Bắt đầu tạo tài khoản của bạn"),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        // Username TextField
                        appTextField(
                          text: "Username",
                          color: AppColors.secondary,
                          hintText: "Nhập username của bạn",
                          obscureText: false,
                          isPasswordField: false,
                          keyboardType: TextInputType.text,
                          func: (value) {
                            ref
                                .read(registerNotifierProvider.notifier)
                                .onUserNameChange(value);
                          },
                          validator: (value) {
                            return _controller.validateUserName(value ?? "");
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Email TextField
                        appTextField(
                          text: "Email",
                          color: AppColors.secondary,
                          hintText: "Nhập email của bạn",
                          isPasswordField: false,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          func: (value) {
                            ref
                                .read(registerNotifierProvider.notifier)
                                .onUserEmailChange(value);
                          },
                          validator: (value) {
                            return _controller.validateEmail(value ?? "");
                          },
                        ),
                        SizedBox(height: 16.h),
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
                                .read(registerNotifierProvider.notifier)
                                .onUserPasswordChange(value);
                          },
                          validator: (value) {
                            return _controller.validatePassword(value ?? "");
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Confirm Password TextField
                        appTextField(
                          text: "Xác nhận mật khẩu",
                          color: AppColors.secondary,
                          hintText: "Nhập lại mật khẩu của bạn",
                          obscureText: !isConfirmPasswordVisible,
                          isPasswordField: true,
                          iconName: isConfirmPasswordVisible
                              ? AppImages.eyeClose
                              : AppImages.eye,
                          onIconTap: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                          func: (value) {
                            ref
                                .read(registerNotifierProvider.notifier)
                                .onUserConfirmPasswordChange(value);
                          },
                          validator: (value) {
                            return _controller.validateConfirmPassword(
                                regProvider.password, value ?? "");
                          },
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          margin: EdgeInsets.only(left: 25.w),
                          child: text14Normal(
                              textAlign: TextAlign.start,
                              text:
                                  "Bằng cách tạo tài khoản, bạn đồng ý với các điều khoản và điều kiện của chúng tôi."),
                        ),
                        SizedBox(height: 16.h),
                        Center(
                          child: appButton(
                            buttonName: "Tạo tài khoản",
                            context: context,
                            isLogin: true,
                            isOutlined: true,
                            buttonColor: AppColors.primary,
                            func: () {
                              // Kiểm tra tất cả các trường khi nhấn nút
                              if (_formKey.currentState!.validate()) {
                                _controller.handleSignUp(context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        appDivider(),
                        SizedBox(height: 16.h),
                        Center(
                          child: appThirdPartyButton(
                            buttonName: "Đăng nhập Google",
                            iconPath: AppImages.google,
                            buttonColor: Colors.white,
                            textColor: Colors.black,
                            isOutlined: true,
                            onTap: () {
                              // Xử lý đăng nhập với Google
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
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
                        SizedBox(height: 16.h),
                        loginPrompt(
                          context: context,
                          func: () {
                            Navigator.pushNamed(context, "/signIn");
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    color: AppColors.primary,
                  ),
                ),
        ),
      ),
    );
  }
}
