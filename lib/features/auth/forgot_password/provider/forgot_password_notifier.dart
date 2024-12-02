import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common/api/forgot_password_api.dart';

part 'forgot_password_notifier.g.dart';

@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  @override
  ForgotPasswordState build() {
    return ForgotPasswordState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email.trim());
  }

  Future<String> sendForgotPassword() async {
    if (state.email.isEmpty) {
      return "Email không được để trống.";
    }

    try {
      final message = await ForgotPasswordApi.sendForgotPasswordEmail(state.email);
      return message ?? "Liên kết đặt lại mật khẩu đã được gửi.";
    } catch (e) {
      return "Không thể gửi email. Vui lòng thử lại sau.";
    }
  }
}

class ForgotPasswordState {
  final String email;

  ForgotPasswordState({this.email = ""});

  ForgotPasswordState copyWith({String? email}) {
    return ForgotPasswordState(email: email ?? this.email);
  }
}
