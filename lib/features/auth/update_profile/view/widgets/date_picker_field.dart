import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final Color borderColor;
  final Color labelColor;
  final Color iconColor;

  const DatePickerField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.borderColor = Colors.grey,
    this.labelColor = Colors.black,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final initialDate = selectedDate ?? DateTime.now();

          final pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );

          onDateSelected(pickedDate);
        } catch (e) {
          debugPrint("Error parsing date: $e");
        }
      },
      child: TextFormField(
        enabled: false, // Prevent manual input
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          suffixIcon: Icon(Icons.calendar_today, color: iconColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
        controller: TextEditingController(
          text: selectedDate != null
              ? "${selectedDate!.day.toString().padLeft(2, '0')}/"
              "${selectedDate!.month.toString().padLeft(2, '0')}/"
              "${selectedDate!.year}"
              : '',
        ),
      ),
    );
  }
}
