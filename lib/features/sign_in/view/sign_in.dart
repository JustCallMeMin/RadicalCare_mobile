import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/sign_in/view/widgets/sign_in_widgets.dart';

import '../../../common/global_loader/global_loaders.dart';
import '../../../common/widgets/app_bar.dart';
import '../../../common/widgets/app_divider.dart';
import '../../../common/widgets/app_textfieds.dart';
import '../controller/sign_in_controllers.dart';
import '../provider/sign_in_notifier.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  late SignInController _controller;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = SignInController(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signInProvider = ref.watch(signInNotifierProvider);
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
                            child: text32Bold(text: "Đăng nhập vào tài khoản"),
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child:
                                text14Normal(text: "Rất vui được gặp lại bạn"),
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        //email textbox
                        appTextField(
                          text: "Email",
                          color: AppColors.secondary,
                          hintText: "Nhập email của bạn",
                          isPasswordField: false,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          func: (value) {
                            ref
                                .read(signInNotifierProvider.notifier)
                                .onUserEmailChange(value);
                          },
                          validator: (value) =>
                              _controller.validateEmail(value ?? ""),
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
                          validator: (value) =>
                              _controller.validatePassword(value ?? ""),
                        ),

                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25.w),
                          child: textUnderline(text: "Quên mật khẩu?"),
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        Center(
                          child: appButton(
                            buttonName: "Đăng nhập",
                            func: () {
                              if (_formKey.currentState!.validate()) {
                                _controller.handleSignIn(context);
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
                            // Thay bằng đường dẫn đến biểu tượng Google của bạn
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
                        // Nút đăng nhập bằng Facebook
                        Center(
                          child: appThirdPartyButton(
                            buttonName: "Đăng nhập bằng Facebook",
                            iconPath: AppImages.facebook,
                            // Thay bằng đường dẫn đến biểu tượng Facebook của bạn
                            buttonColor: Colors.blue,
                            // Màu nền xanh của Facebook
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
                            Navigator.pushNamed(context, "/signUp");
                          },
                        )
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
