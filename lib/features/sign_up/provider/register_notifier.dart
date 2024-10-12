import 'package:radicalcare/features/sign_up/provider/register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_notifier.g.dart';
@riverpod
class RegisterNotifier extends _$RegisterNotifier{
  @override
  RegisterState build() {
    return RegisterState();
  }
  void onUserNameChange(String userName){
    state = state.copyWhith(userName: userName);
  }
  void onUserEmailChange(String email){
    state = state.copyWhith(email: email);
  }
  void onUserPasswordChange(String password){
    state = state.copyWhith(password: password);
  }
  void onUserConfirmPasswordChange(String confirmPassword){
    state = state.copyWhith(confirmPassword: confirmPassword);
  }
}