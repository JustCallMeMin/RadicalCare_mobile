import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common/api/api_config.dart';
import '../../../../common/api/auth_service_api.dart';
import '../../../../common/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

part 'sign_in_notifier.g.dart';

@riverpod
class SignInNotifier extends _$SignInNotifier {
  final AuthService _authService = AuthService();

  @override
  SignInState build() {
    return SignInState();
  }

  /// Đăng nhập bằng Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print("Google Sign-In process started.");

      // Gọi AuthService để xử lý Google Sign-In
      await _authService.signInWithGoogle();

      // Lấy token từ SecureStorage
      final token = await _authService.getToken();
      if (token != null) {
        // Lưu token vào SecureStorage
        await SecureStorageManager.saveToken(token);
        print("Token saved successfully after Google Sign-In.");

        state = state.copyWith(isSignedIn: true);
      } else {
        state = state.copyWith(errorMessage: "Failed to retrieve token after Google Sign-In");
      }
    } catch (error) {
      print("Error during Google Sign-In: $error");
      state = state.copyWith(errorMessage: "An error occurred: $error");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Xử lý thay đổi username
  void onUsernameChange(String value) {
    state = state.copyWith(username: value);
  }

  /// Xử lý thay đổi password
  void onUserPasswordChange(String value) {
    state = state.copyWith(password: value);
  }

  /// Xác thực username
  String? validateUsername(String username) {
    if (username.isEmpty) return 'Username của bạn đang trống';
    return null;
  }

  /// Xác thực password
  String? validatePassword(String password) {
    if (password.isEmpty) return 'Mật khẩu của bạn đang trống';
    if (password.length < 6) return 'Mật khẩu của bạn chưa đủ 6 ký tự';
    return null;
  }

  /// Đăng nhập bằng username và password
  Future<void> signInUser() async {
    if (validateUsername(state.username) != null || validatePassword(state.password) != null) {
      state = state.copyWith(errorMessage: "Validation failed");
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _authService.signIn(state.username, state.password);
      if (response['success'] == true) {
        final token = response['token'] as String?;
        if (token != null) {
          await SecureStorageManager.saveToken(token);
          state = state.copyWith(isSignedIn: true);
        } else {
          state = state.copyWith(errorMessage: "Token is missing in response");
        }
      } else {
        state = state.copyWith(errorMessage: response['message'] ?? "Login failed");
      }
    } catch (error) {
      state = state.copyWith(errorMessage: "An error occurred: $error");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Reset form
  void resetForm() {
    state = SignInState();
  }
}

class SignInState {
  final String username;
  final String password;
  final bool isLoading;
  final bool isSignedIn;
  final String? errorMessage;

  SignInState({
    this.username = "",
    this.password = "",
    this.isLoading = false,
    this.isSignedIn = false,
    this.errorMessage,
  });

  SignInState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    bool? isSignedIn,
    String? errorMessage,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
