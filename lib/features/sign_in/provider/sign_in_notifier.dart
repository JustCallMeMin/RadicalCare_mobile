import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../common/api/auth_service_api.dart';
import '../../../common/utils/secure_storage.dart'; // Import SecureStorageManager

part 'sign_in_notifier.g.dart';

@riverpod
class SignInNotifier extends _$SignInNotifier {
  final AuthService _authService = AuthService();

  @override
  SignInState build() {
    return SignInState(username: "", password: "", isLoading: false);
  }

  void onUsernameChange(String value) {
    state = state.copyWith(username: value);
  }

  void onUserPasswordChange(String value) {
    state = state.copyWith(password: value);
  }

  String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username của bạn đang trống';
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

  Future<String?> signInUser() async {
    // Validate username và password trước khi gửi request.
    if (validateUsername(state.username) != null ||
        validatePassword(state.password) != null) {
      print("SignInNotifier: Validation failed.");
      return null;
    }

    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.signIn(state.username, state.password);

      if (response['success']) {
        final token = response['token'];
        print("SignInNotifier: Received token - $token");

        // Lưu token
        await SecureStorageManager.saveToken(token);

        return token;
      } else {
        print("SignInNotifier: Login failed - ${response['message']}");
        return null;
      }
    } catch (error) {
      print('SignInNotifier: Error during sign-in: $error');
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void resetForm() {
    state = SignInState(username: "", password: "", isLoading: false);
  }
}

class SignInState {
  final String username;
  final String password;
  final bool isLoading;

  SignInState({
    required this.username,
    required this.password,
    required this.isLoading,
  });

  SignInState copyWith({
    String? username,
    String? password,
    bool? isLoading,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
