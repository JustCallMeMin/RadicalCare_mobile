import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common/api/forgot_password_api.dart';

part 'reset_password_notifier.g.dart';

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  @override
  FutureOr<void> build() {
    // Không cần trạng thái ban đầu đặc biệt
  }

  /// Thực hiện đặt lại mật khẩu
  Future<String?> resetPassword(String token, String newPassword) async {
    try {
      final message = await ForgotPasswordApi.resetPassword(token, newPassword);
      return message; // Trả về thông báo thành công
    } catch (e) {
      return "Không thể đặt lại mật khẩu. Vui lòng thử lại.";
    }
  }
}
