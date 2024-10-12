import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radicalcare/features/sign_in/provider/sign_in_state.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  SignInNotifier() : super(SignInState());

  void onUserEmailChange(String email) {
    state = state.copyWhith(email: email);
  }

  void onUserPasswordChange(String password) {
    state = state.copyWhith(password: password);
  }
}

final signInNotifierProvider =
    StateNotifierProvider<SignInNotifier, SignInState>(
        (ref) => SignInNotifier());
