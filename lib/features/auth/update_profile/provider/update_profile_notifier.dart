import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:radicalcare/common/api/auth_service_api.dart';

part 'update_profile_notifier.g.dart';

@riverpod
class UpdateProfileNotifier extends _$UpdateProfileNotifier {
  final AuthService _authService = AuthService();

  @override
  UpdateProfileState build() {
    return UpdateProfileState(
      fullName: null,
      email: null,
      phone: null,
      address: null,
      doB: null,
      isLoading: false,
    );
  }

  void onFullNameChange(String? value) {
    state = state.copyWith(fullName: value);
  }

  void onEmailChange(String? value) {
    state = state.copyWith(email: value);
  }

  void onPhoneChange(String? value) {
    state = state.copyWith(phone: value);
  }

  void onAddressChange(String? value) {
    state = state.copyWith(address: value);
  }

  void onDoBChange(String? value) {
    state = state.copyWith(doB: value);
  }

  // Gửi yêu cầu cập nhật thông tin người dùng
  Future<Map<String, dynamic>> submitProfile() async {
    state = state.copyWith(isLoading: true);

    // Tạo JSON chứa các trường không null
    final Map<String, dynamic> profileData = {};
    if (state.fullName != null) profileData['fullName'] = state.fullName;
    if (state.email != null) profileData['email'] = state.email;
    if (state.phone != null) profileData['phone'] = state.phone;
    if (state.address != null) profileData['address'] = state.address;
    if (state.doB != null) profileData['doB'] = state.doB;

    try {
      final response = await _authService.updateProfile();

      state = state.copyWith(isLoading: false);

      return response;
    } catch (error) {
      state = state.copyWith(isLoading: false);

      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }
}

class UpdateProfileState {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? address;
  final String? doB;
  final bool isLoading;

  UpdateProfileState({
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.doB,
    this.isLoading = false,
  });

  UpdateProfileState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? doB,
    bool? isLoading,
  }) {
    return UpdateProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      doB: doB ?? this.doB,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
