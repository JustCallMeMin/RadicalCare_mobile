import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/update_profile_notifier.dart';
import 'widgets/profile_input_field.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/submit_button.dart';

class UpdateProfilePage extends ConsumerWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateProfileNotifier = ref.read(updateProfileNotifierProvider.notifier);
    final updateProfileState = ref.watch(updateProfileNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cập nhật thông tin"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileInputField(
              label: "Họ và tên",
              onChanged: (value) => updateProfileNotifier.onFullNameChange(value.isEmpty ? null : value),
            ),
            ProfileInputField(
              label: "Email",
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => updateProfileNotifier.onEmailChange(value.isEmpty ? null : value),
            ),
            ProfileInputField(
              label: "Số điện thoại",
              keyboardType: TextInputType.phone,
              onChanged: (value) => updateProfileNotifier.onPhoneChange(value.isEmpty ? null : value),
            ),
            ProfileInputField(
              label: "Địa chỉ",
              onChanged: (value) => updateProfileNotifier.onAddressChange(value.isEmpty ? null : value),
            ),
            DatePickerField(
              label: "Chọn ngày sinh",
              selectedDate: updateProfileState.doB,
              onDateSelected: (date) => updateProfileNotifier.onDoBChange(date),
            ),
            SizedBox(height: 20.h),
            SubmitButton(
              isLoading: updateProfileState.isLoading,
              onPressed: () async {
                final response = await updateProfileNotifier.submitProfile();
                final message = response['success']
                    ? "Cập nhật thông tin thành công!"
                    : (response['message'] ?? "Cập nhật thất bại!");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
