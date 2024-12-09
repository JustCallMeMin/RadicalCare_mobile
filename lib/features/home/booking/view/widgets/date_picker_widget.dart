import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provider/booking_notifier.dart';

class DatePickerWidget extends ConsumerWidget {
  const DatePickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);
    final selectedDate = ref.watch(bookingNotifierProvider).date;

    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          bookingNotifier.updateDate(pickedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          selectedDate != null
              ? selectedDate.toLocal().toString().split(' ')[0]
              : 'Chọn ngày',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
