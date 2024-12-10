import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/utils/colors.dart';
import '../provider/update_profile_notifier.dart';
import 'widgets/profile_input_field.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/submit_button.dart';

class UpdateProfilePage extends ConsumerWidget {
  UpdateProfilePage({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateProfileNotifier = ref.read(updateProfileNotifierProvider.notifier);
    final updateProfileState = ref.watch(updateProfileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        title: const Text(
          "Cập nhật thông tin",
          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Kiểm tra lỗi ngay khi người dùng nhập
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hãy nhập thông tin cá nhân của bạn",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              // Full Name TextField
              ProfileInputField(
                label: "Họ và tên",
                onChanged: updateProfileNotifier.onFullNameChange,
                borderColor: AppColors.content,
                labelColor: AppColors.secondary,
                validator: (value) => updateProfileNotifier.validateFullName(),
              ),
              ProfileInputField(
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => updateProfileNotifier.onEmailChange(value),
                borderColor: AppColors.content,
                labelColor: AppColors.secondary,
                validator: (value) => updateProfileNotifier.validateEmail(value ?? ""),
              ),
              ProfileInputField(
                label: "Số điện thoại",
                keyboardType: TextInputType.phone,
                onChanged: (value) => updateProfileNotifier.onPhoneChange(value),
                borderColor: AppColors.content,
                labelColor: AppColors.secondary,
                validator: (value) => updateProfileNotifier.validatePhone(value ?? ""),
              ),
              ProfileInputField(
                label: "Địa chỉ",
                onChanged: updateProfileNotifier.onAddressChange,
                borderColor: AppColors.content,
                labelColor: AppColors.secondary,
                validator: (value) => updateProfileNotifier.validateAddress(value ?? ""),
              ),
              DatePickerField(
                label: "Chọn ngày sinh",
                selectedDate: updateProfileState.doB != null
                    ? DateTime.tryParse(updateProfileState.doB!)
                    : null,
                onDateSelected: (value) {
                  updateProfileNotifier.onDoBChange(value);
                },
                borderColor: AppColors.content,
                labelColor: AppColors.secondary,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 20),
              SubmitButton(
                isLoading: updateProfileState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await updateProfileNotifier.submitProfile();
                    final message = response['success']
                        ? "Cập nhật thông tin thành công!"
                        : (response['message'] ?? "Cập nhật thất bại!");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      backgroundColor: response['success'] ? Colors.green : Colors.red,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Vui lòng kiểm tra lại thông tin!"),
                      backgroundColor: Colors.orange,
                    ));
                  }
                },
                buttonColor: AppColors.primary,
                textColor: AppColors.primaryBg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
