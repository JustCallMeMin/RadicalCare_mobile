import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:radicalcare/common/widgets/text_widgets.dart';

import '../../features/search/view/search.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'image_widgets.dart';

Widget appTextField({
  String text = "",
  String iconVisible = AppImages.eyeClose,
  String iconHidden = AppImages.eye,
  String iconName = AppImages.eyeClose,

  String hintText = "",
  bool isPasswordField = true,
  bool obscureText = false,
  bool isDirty = false,
  Color color = AppColors.content,
  TextInputType keyboardType = TextInputType.text,
  void Function(String value)? func,
  void Function()? onIconTap,
  String? Function(String?)? validator,
}) {
  return Container(
    padding: EdgeInsets.only(left: 25.w, right: 25.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text14Normal(text: text, color: color),
        SizedBox(height: 5.h),
        TextFormField(
          onChanged: (value) {
            func?.call(value);
          },
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.content),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.secondary,
                width: 1.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5.w,
              ),
            ),
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            // Sử dụng suffixIcon để giữ cố định biểu tượng mắt
            suffixIcon: isPasswordField
                ? GestureDetector(
              onTap: onIconTap,
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: appImage(
                  imagePath: obscureText ? iconVisible : iconHidden,
                ),
              ),
            )
                : null,
          ),
          maxLines: 1,
          autocorrect: false,
          obscureText: isPasswordField ? obscureText : false,
          validator: validator,
        ),
      ],
    ),
  );
}

Widget appDatePicker({
  required BuildContext context,
  required String label,
  required String hintText,
  required TextEditingController controller,
  required void Function(DateTime selectedDate) onDateSelected,
  DateTime? initialDate, // Không cần const
  DateTime? firstDate, // Không cần const
  DateTime? lastDate, // Không cần const
}) {
  return Container(
    padding: EdgeInsets.only(left: 25.w, right: 25.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.content,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: () async {
            // Hiển thị DatePicker
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(), // Sử dụng giá trị mặc định
              firstDate: firstDate ?? DateTime(1900), // Sử dụng giá trị mặc định
              lastDate: lastDate ?? DateTime.now(), // Sử dụng giá trị mặc định
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary, // Màu chính
                      onPrimary: Colors.white, // Màu chữ
                      onSurface: AppColors.secondary, // Màu nền
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary, // Màu nút
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            // Nếu người dùng chọn ngày
            if (pickedDate != null) {
              onDateSelected(pickedDate); // Gọi hàm callback
              controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Cập nhật TextField
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.content),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.secondary, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.secondary, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.w),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.5.w),
                ),
                errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn ngày sinh';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget appSearchBar({
  required String hintText,
  required Function(String value) onSearch,
  required VoidCallback onVoiceSearchTap,
  required BuildContext context,
  required TextEditingController searchController,
  required VoidCallback onClearSearch, // Hàm được gọi khi nội dung bị xóa hết
  required FocusNode focusNode, // FocusNode để quản lý focus
  bool isOnSearchPage = false, // Xác định đang ở SearchPage hay không
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    height: 50.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.search, color: Colors.grey),
        SizedBox(width: 10.w),
        Flexible(
          child: TextField(
            controller: searchController,
            focusNode: focusNode, // Gắn FocusNode
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            onTap: () {
              if (!isOnSearchPage) {
                // Nếu chưa ở SearchPage, chuyển sang SearchPage khi nhấn vào
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchPage(keyword: searchController.text),
                  ),
                );
              }
            },
            onChanged: (value) {
              if (isOnSearchPage && value.isEmpty) {
                // Khi nội dung bị xóa hết, gọi hàm onClearSearch
                onClearSearch();
              }
            },
            onSubmitted: (value) {
              if (isOnSearchPage && value.isNotEmpty) {
                // Nếu đã ở SearchPage, thực hiện tìm kiếm
                onSearch(value);
              }
            },
          ),
        ),
        GestureDetector(
          onTap: onVoiceSearchTap,
          child: const Icon(Icons.mic, color: Colors.grey),
        ),
      ],
    ),
  );
}

