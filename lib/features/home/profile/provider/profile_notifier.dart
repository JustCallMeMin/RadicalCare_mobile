import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/utils/secure_storage.dart';
import '../../../../common/api/api_config.dart';

part 'profile_notifier.g.dart';

// Notifier để quản lý trạng thái của Profile
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  bool _hasFetched = false; // Cờ để kiểm tra dữ liệu đã được tải hay chưa

  @override
  ProfileState build() {
    // Trạng thái mặc định
    return ProfileState(
      userName: "Default User",
      email: "default@example.com",
      phone: "0123456789",
      imagePath: null,
    );
  }

  Future<void> fetchUserProfile() async {
    if (_hasFetched) return; // Nếu đã gọi API trước đó, thoát luôn
    _hasFetched = true;

    try {
      final token = await SecureStorageManager.getToken();
      if (token == null) {
        throw Exception("No token found.");
      }

      final response = await http.get(
        Uri.parse("${baseUrl}/auth/fetch-user"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        state = state.copyWith(
          userName: data['username'], // Gán đúng dữ liệu từ JSON trả về
          email: data['email'],
          phone: data['phone'], // Gán số điện thoại nếu có
        );
      } else {
        throw Exception("Failed to fetch user profile");
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  // Cập nhật trạng thái người dùng
  void updateProfile({
    required String email,
    required String username,
    required String phone,
    required String password, // Không lưu trực tiếp mật khẩu
  }) {
    state = state.copyWith(
      email: email,
      userName: username,
      phone: phone,
    );
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    try {
      await SecureStorageManager.clearToken(); // Xóa token khỏi storage
      await SecureStorageManager.clearAllData(); // Xóa toàn bộ dữ liệu (nếu cần)
      state = state.copyWith(isLoggedOut: true); // Cập nhật trạng thái đăng xuất
      print("Logout successful.");
    } catch (e) {
      print("Error during logout: $e");
    }
  }
}

// Trạng thái Profile
class ProfileState {
  final String? userName;
  final String? email;
  final String? phone;
  final String? imagePath;
  final bool isLoggedOut; // Trạng thái đăng xuất

  ProfileState({
    required this.userName,
    required this.email,
    required this.phone,
    this.imagePath,
    this.isLoggedOut = false, // Mặc định là chưa đăng xuất
  });

  // Hàm copyWith để cập nhật trạng thái
  ProfileState copyWith({
    String? userName,
    String? email,
    String? phone,
    String? imagePath,
    bool? isLoggedOut, // Cập nhật trạng thái đăng xuất
  }) {
    return ProfileState(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }
}
