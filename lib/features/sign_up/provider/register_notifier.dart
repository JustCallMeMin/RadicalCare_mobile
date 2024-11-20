import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/api/auth_service_api.dart';
import '../../../common/routes/app_routes_name.dart';

part 'register_notifier.g.dart';

@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  final AuthService _authService = AuthService();

  @override
  RegisterState build() {
    return RegisterState(
      fullName: "",
      userName: "",
      email: "",
      password: "",
      confirmPassword: "",
      address: "",
      doB: "",
      isLoading: false,
    );
  }

  void onFullNameChange(String value) {
    state = state.copyWith(fullName: value);
  }

  void onUserNameChange(String value) {
    state = state.copyWith(userName: value);
  }

  void onUserEmailChange(String value) {
    state = state.copyWith(email: value);
  }

  void onUserPasswordChange(String value) {
    state = state.copyWith(password: value);
  }

  void onUserConfirmPasswordChange(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  void onAddressChange(String value) {
    state = state.copyWith(address: value);
  }

  void onDoBChange(String value) {
    state = state.copyWith(doB: value);
  }

  String? validateFullName() {
    if (state.fullName.isEmpty) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }

  String? validateUserName() {
    if (state.userName.isEmpty) {
      return 'Username của bạn đang trống';
    }
    if (state.userName.length < 6) {
      return 'Username của bạn chưa đủ 6 ký tự';
    }
    return null;
  }

  String? validateEmail() {
    if (state.email.isEmpty) {
      return 'Email của bạn đang trống';
    }
    const emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(state.email)) {
      return 'Vui lòng điền đúng email';
    }
    return null;
  }

  String? validatePassword() {
    if (state.password.isEmpty) {
      return 'Mật khẩu của bạn đang trống';
    }
    if (state.password.length < 6) {
      return 'Mật khẩu của bạn chưa đủ 6 ký tự';
    }
    return null;
  }

  String? validateConfirmPassword() {
    if (state.confirmPassword.isEmpty) {
      return 'Xác nhận mật khẩu của bạn đang trống';
    }
    if (state.password != state.confirmPassword) {
      return 'Mật khẩu và xác nhận mật khẩu không khớp';
    }
    return null;
  }

  String? validateAddress() {
    if (state.address.isEmpty) {
      return 'Địa chỉ không được để trống';
    }
    return null;
  }

  String? validateDoB() {
    if (state.doB.isEmpty) {
      return 'Ngày sinh không được để trống';
    }
    // Bạn có thể thêm logic kiểm tra định dạng ngày tháng ở đây
    return null;
  }

  Future<void> handleSignUp(BuildContext context) async {
    // Validate input trước khi gửi request
    if (validateFullName() != null ||
        validateUserName() != null ||
        validateEmail() != null ||
        validatePassword() != null ||
        validateConfirmPassword() != null ||
        validateAddress() != null ||
        validateDoB() != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin đăng ký không hợp lệ')),
      );
      return;
    }

    state = state.copyWith(isLoading: true); // Bắt đầu trạng thái tải

    try {
      final response = await _authService.registerUser(
        fullName: state.fullName,
        userName: state.userName,
        email: state.email,
        password: state.password,
        address: state.address,
        doB: state.doB,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công. Vui lòng kiểm tra email xác minh.')),
        );

        Navigator.pushReplacementNamed(context, AppRoutesNames.SIGN_IN);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Đăng ký thất bại')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi trong quá trình đăng ký.')),
      );
    } finally {
      state = state.copyWith(isLoading: false); // Kết thúc trạng thái tải
    }
  }

  void resetForm() {
    state = RegisterState(
      fullName: "",
      userName: "",
      email: "",
      password: "",
      confirmPassword: "",
      address: "",
      doB: "",
      isLoading: false,
    );
  }
}

class RegisterState {
  final String fullName;
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String address;
  final String doB;
  final bool isLoading;

  RegisterState({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.address,
    required this.doB,
    required this.isLoading,
  });

  RegisterState copyWith({
    String? fullName,
    String? userName,
    String? email,
    String? password,
    String? confirmPassword,
    String? address,
    String? doB,
    bool? isLoading,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      address: address ?? this.address,
      doB: doB ?? this.doB,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
