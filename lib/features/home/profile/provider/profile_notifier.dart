import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/utils/secure_storage.dart';


part 'profile_notifier.g.dart';

// Notifier để quản lý trạng thái của Profile
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    // Trạng thái mặc định khi khởi tạo
    return ProfileState(
      userName: "Default User",
      email: "default@example.com",
      phone: "0123456789",
      imagePath: null,
    );
  }
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
}

// Trạng thái Profile
class ProfileState {
  final String? userName;
  final String? email;
  final String? phone;
  final String? imagePath;
  final bool isLoggedOut; // Thêm trạng thái đăng xuất

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
    bool? isLoggedOut, // Thêm tham số này để cập nhật trạng thái đăng xuất
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

