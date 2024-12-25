import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:radicalcare/common/utils/colors.dart';
import 'package:radicalcare/common/utils/images.dart';
import 'package:radicalcare/common/widgets/button_widgets.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';
import 'package:radicalcare/common/widgets/app_divider.dart';
import 'package:radicalcare/common/widgets/app_textfieds.dart';
import 'package:radicalcare/common/routes/app_routes_name.dart';
import 'package:radicalcare/features/auth/sign_in/view/widgets/sign_in_widgets.dart';
import '../provider/sign_in_notifier.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  bool isPasswordVisible = false; // Điều khiển hiển thị mật khẩu
  final _formKey = GlobalKey<FormState>(); // Khóa để xác thực biểu mẫu

  /// Xử lý đăng nhập bằng username và password
  Future<void> _handleSignIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(signInNotifierProvider.notifier);
      await notifier.signInUser();

      final isSignedIn = ref.read(signInNotifierProvider).isSignedIn;
      if (isSignedIn) {
        Navigator.pushReplacementNamed(context, AppRoutesNames.APPLICATION);
      } else {
        _showErrorSnackbar(context, ref.read(signInNotifierProvider).errorMessage ??
            "Đăng nhập thất bại, vui lòng thử lại.");
      }
    }
  }

  /// Xử lý đăng nhập bằng Google
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final notifier = ref.read(signInNotifierProvider.notifier);
      await notifier.signInWithGoogle();

      final isSignedIn = ref.read(signInNotifierProvider).isSignedIn;
      if (isSignedIn) {
        Navigator.pushReplacementNamed(context, AppRoutesNames.APPLICATION);
      } else {
        _showErrorSnackbar(context, ref.read(signInNotifierProvider).errorMessage ??
            "Đăng nhập Google thất bại, vui lòng thử lại.");
      }
    } catch (e) {
      _showErrorSnackbar(context, "Đăng nhập Google thất bại: $e");
    }
  }

  /// Hiển thị Snackbar lỗi
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final signInNotifier = ref.watch(signInNotifierProvider);

    return Container(
      color: AppColors.primaryBg,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryBg,
          body: signInNotifier.isLoading
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
                  _buildHeader(),
                  SizedBox(height: 38.h),
                  _buildUsernameField(),
                  SizedBox(height: 16.h),
                  _buildPasswordField(),
                  SizedBox(height: 16.h),
                  _buildForgotPassword(context),
                  SizedBox(height: 100.h),
                  _buildSignInButton(context),
                  SizedBox(height: 20.h),
                  appDivider(),
                  SizedBox(height: 20.h),
                  _buildGoogleSignInButton(context),
                  SizedBox(height: 20.h),
                  _buildRegisterPrompt(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header Section
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text32Bold(text: "Đăng nhập tài khoản"),
          text14Normal(text: "Rất vui được gặp lại bạn"),
        ],
      ),
    );
  }

  /// Username Field
  Widget _buildUsernameField() {
    return appTextField(
      text: "Username",
      color: AppColors.secondary,
      hintText: "Nhập username của bạn",
      isPasswordField: false,
      obscureText: false,
      keyboardType: TextInputType.text,
      func: (value) =>
          ref.read(signInNotifierProvider.notifier).onUsernameChange(value),
      validator: (value) => ref
          .read(signInNotifierProvider.notifier)
          .validateUsername(value ?? ""),
    );
  }

  /// Password Field
  Widget _buildPasswordField() {
    return appTextField(
      text: "Mật khẩu",
      color: AppColors.secondary,
      hintText: "Nhập mật khẩu của bạn",
      obscureText: !isPasswordVisible,
      isPasswordField: true,
      iconName: isPasswordVisible ? AppImages.eyeClose : AppImages.eye,
      onIconTap: () {
        setState(() {
          isPasswordVisible = !isPasswordVisible;
        });
      },
      func: (value) =>
          ref.read(signInNotifierProvider.notifier).onUserPasswordChange(value),
      validator: (value) => ref
          .read(signInNotifierProvider.notifier)
          .validatePassword(value ?? ""),
    );
  }

  /// Forgot Password Section
  Widget _buildForgotPassword(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutesNames.FORGOT_PASSWORD);
        },
        child: textUnderline(text: "Quên mật khẩu?"),
      ),
    );
  }

  /// Sign-In Button
  Widget _buildSignInButton(BuildContext context) {
    return Center(
      child: appButton(
        buttonName: "Đăng nhập",
        func: () => _handleSignIn(context),
      ),
    );
  }

  /// Google Sign-In Button
  Widget _buildGoogleSignInButton(BuildContext context) {
    return Center(
      child: appThirdPartyButton(
        buttonName: "Đăng nhập bằng Google",
        iconPath: AppImages.google,
        buttonColor: Colors.white,
        textColor: Colors.black,
        isOutlined: true,
        onTap: () => _handleGoogleSignIn(context),
      ),
    );
  }

  /// Register Prompt
  Widget _buildRegisterPrompt(BuildContext context) {
    return registerPrompt(
      context: context,
      func: () => Navigator.pushNamed(context, AppRoutesNames.SIGN_UP),
    );
  }
}
