import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomePageIndex extends _$HomePageIndex {
  @override
  int build() {
    return 0;  // Chỉ số mặc định là trang đầu tiên
  }

  void changeIndex(int value) {
    state = value;  // Cập nhật trạng thái khi chỉ số thay đổi
  }
}
