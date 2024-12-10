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
      emailError: null,
      phoneError: null,
    );
  }

  // Handle changes for Full Name
  void onFullNameChange(String? value) {
    state = state.copyWith(fullName: value);
  }

  // Handle changes for Email with validation
  void onEmailChange(String? value) {
    final emailError = value != null && value.isNotEmpty ? validateEmail(value) : null;
    state = state.copyWith(email: value, emailError: emailError);
  }

  // Handle changes for Phone with validation
  void onPhoneChange(String? value) {
    final phoneError = value != null && value.isNotEmpty ? validatePhone(value) : null;
    state = state.copyWith(phone: value, phoneError: phoneError);
  }

  // Handle changes for Address
  void onAddressChange(String? value) {
    state = state.copyWith(address: value);
  }

  // Handle changes for Date of Birth
  void onDoBChange(DateTime? value) {
    state = state.copyWith(doB: value?.toIso8601String());
  }

  // Full Name Validation (check length and only if there's a value)
  String? validateFullName() {
    if (state.fullName?.isNotEmpty ?? false) {
      if (state.fullName!.length < 3) {
        return 'Họ và tên phải có ít nhất 3 ký tự';
      } else if (state.fullName!.length > 100) {
        return 'Họ và tên không được quá 100 ký tự';
      }
    }
    return null;
  }


  // Email Validation (only if there's a value)
  String? validateEmail(String email) {
    // Không kiểm tra null hoặc rỗng nếu không có giá trị
    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        return 'Định dạng email không hợp lệ';
      }
    }
    return null;
  }

// Phone Validation (only if there's a value)
  String? validatePhone(String phone) {
    // Không kiểm tra null hoặc rỗng nếu không có giá trị
    if (phone.isNotEmpty) {
      if (phone.length < 10 || phone.length > 15) {
        return 'Số điện thoại phải từ 10 đến 15 ký tự';
      }
    }
    return null;
  }

  // Address Validation (check only if value is provided)
  String? validateAddress(String address) {
    if (address.isNotEmpty && address.length < 5) {
      return 'Địa chỉ phải có ít nhất 5 ký tự';
    }
    return null;
  }

  // Submit profile data to server
  Future<Map<String, dynamic>> submitProfile() async {
    // Kiểm tra nếu tất cả các trường đều trống
    if ((state.fullName?.isEmpty ?? true) &&
        (state.email?.isEmpty ?? true) &&
        (state.phone?.isEmpty ?? true) &&
        (state.address?.isEmpty ?? true) &&
        (state.doB?.isEmpty ?? true)) {
      return {"success": false, "message": "Không có chi tiết nào cập nhật"};
    }

    // Kiểm tra email và phone nếu có giá trị
    final emailError = state.email != null ? validateEmail(state.email!) : null;
    final phoneError = state.phone != null ? validatePhone(state.phone!) : null;

    if (emailError != null || phoneError != null) {
      state = state.copyWith(emailError: emailError, phoneError: phoneError);
      return {"success": false, "message": "Thông tin không hợp lệ"};
    }

    state = state.copyWith(isLoading: true);

    // Tạo dữ liệu profile
    final profileData = {
      if (state.fullName != null) "fullName": state.fullName,
      if (state.email != null) "email": state.email,
      if (state.phone != null) "phone": state.phone,
      if (state.address != null) "address": state.address,
      if (state.doB != null) "doB": state.doB,
    };

    try {
      // Gửi request cập nhật profile
      final response = await _authService.updateProfile(profileData);

      state = state.copyWith(
        isLoading: false,
        emailError: response["success"] == true ? null : state.emailError,
        phoneError: response["success"] == true ? null : state.phoneError,
      );

      return response;
    } catch (error) {
      state = state.copyWith(isLoading: false);
      return {"success": false, "message": "Đã xảy ra lỗi: $error"};
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
  final String? emailError;
  final String? phoneError;

  UpdateProfileState({
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.doB,
    this.isLoading = false,
    this.emailError,
    this.phoneError,
  });

  UpdateProfileState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? doB,
    bool? isLoading,
    String? emailError,
    String? phoneError,
  }) {
    return UpdateProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      doB: doB ?? this.doB,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError ?? this.emailError,
      phoneError: phoneError ?? this.phoneError,
    );
  }
}
