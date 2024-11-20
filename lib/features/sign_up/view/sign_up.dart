import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/app_divider.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/features/sign_up/view/widgets/sign_up_widgets.dart';
import '../../../common/widgets/app_textfieds.dart';
import '../provider/register_notifier.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerNotifier = ref.watch(registerNotifierProvider);
    final registerNotifierNotifier =
    ref.read(registerNotifierProvider.notifier);

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
                  SizedBox(height: 38.h),
                  // Full Name TextField
                  appTextField(
                    text: "Họ và tên",
                    color: AppColors.secondary,
                    hintText: "Nhập họ và tên của bạn",
                    obscureText: false,
                    isPasswordField: false,
                    keyboardType: TextInputType.name,
                    func: registerNotifierNotifier.onFullNameChange,
                    validator: (_) =>
                        registerNotifierNotifier.validateFullName(),
                  ),
                  SizedBox(height: 16.h),
                  // Username TextField
                  appTextField(
                    text: "Username",
                    color: AppColors.secondary,
                    hintText: "Nhập username của bạn",
                    obscureText: false,
                    isPasswordField: false,
                    keyboardType: TextInputType.text,
                    func: registerNotifierNotifier.onUserNameChange,
                    validator: (_) =>
                        registerNotifierNotifier.validateUserName(),
                  ),
                  SizedBox(height: 16.h),
                  // Email TextField
                  appTextField(
                    text: "Email",
                    color: AppColors.secondary,
                    hintText: "Nhập email của bạn",
                    obscureText: false,
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                    func: registerNotifierNotifier.onUserEmailChange,
                    validator: (_) => registerNotifierNotifier.validateEmail(),
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
                    func: registerNotifierNotifier.onUserPasswordChange,
                    validator: (_) =>
                        registerNotifierNotifier.validatePassword(),
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
                    func: registerNotifierNotifier.onUserConfirmPasswordChange,
                    validator: (_) =>
                        registerNotifierNotifier.validateConfirmPassword(),
                  ),
                  SizedBox(height: 16.h),
                  // Address TextField
                  appTextField(
                    text: "Địa chỉ",
                    color: AppColors.secondary,
                    hintText: "Nhập địa chỉ của bạn",
                    obscureText: false,
                    isPasswordField: false,
                    keyboardType: TextInputType.streetAddress,
                    func: registerNotifierNotifier.onAddressChange,
                    validator: (_) => registerNotifierNotifier.validateAddress(),
                  ),
                  SizedBox(height: 16.h),
                  // Date of Birth TextField
                  appDatePicker(
                    context: context,
                    label: "Ngày sinh",
                    hintText: "Chọn ngày sinh",
                    controller: TextEditingController()
                      ..text = ref.watch(registerNotifierProvider).doB,
                    onDateSelected: (selectedDate) {
                      ref
                          .read(registerNotifierProvider.notifier)
                          .onDoBChange("${selectedDate.toLocal()}".split(' ')[0]);
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
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
                      buttonName: registerNotifier.isLoading
                          ? "Đang xử lý..."
                          : "Tạo tài khoản",
                      func: registerNotifier.isLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          registerNotifierNotifier.handleSignUp(
                              context);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  appDivider(),
                  SizedBox(height: 16.h),
                  loginPrompt(
                    context: context,
                    func: () {
                      Navigator.pushNamed(context, "/signIn");
                    },
                  ),
                  SizedBox(height: 20.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
