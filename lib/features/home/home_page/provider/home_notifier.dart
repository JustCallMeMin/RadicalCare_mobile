import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/home_api.dart'; // Import API

part 'home_notifier.g.dart';

@riverpod
class HomePageIndex extends _$HomePageIndex {
  @override
  int build() {
    return 0;  // Chỉ số mặc định là trang đầu tiên
  }

  // Tạo state cho fullname
  String? fullName;

  // Hàm lấy fullname của người dùng
  Future<void> fetchUserFullName() async {
    try {
      final user = await fetchUserInfo(); // Gọi API để lấy thông tin người dùng
      fullName = user.fullName; // Cập nhật fullname
      state = state; // Cập nhật state để UI có thể re-render
    } catch (e) {
      print("Error fetching user info: $e");
    }
  }

  void changeIndex(int value) {
    state = value;  // Cập nhật trạng thái khi chỉ số thay đổi
  }
}