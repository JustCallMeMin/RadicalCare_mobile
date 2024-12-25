import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:radicalcare/common/utils/colors.dart';

// Widget để hiển thị các lựa chọn như phân khúc (segment), màu sắc (color), sold
Widget buildChoiceChips({
  required List<String> options,
  required List<String> selectedOptions, // Đổi từ String thành List<String> để hỗ trợ chọn nhiều mục
  required Function(String) onSelected,
}) {
  return Wrap(
    spacing: 10,
    children: options.asMap().entries.map((entry) {
      int index = entry.key;
      String option = entry.value;
      return ChoiceChip(
        label: Text(option),
        selected: selectedOptions.contains(option), // Kiểm tra nếu `option` đã được chọn
        onSelected: (selected) => onSelected(option),
        selectedColor: AppColors.primary,
      );
    }).toList(),
  );
}

// Widget để hiển thị bộ lọc sold
Widget buildSoldFilter({
  required bool? soldValue,
  required Function(bool?) onChanged,
}) {
  return DropdownButton<bool?>(
    value: soldValue,
    hint: const Text("Tình trạng"),
    items: const [
      DropdownMenuItem(value: true, child: Text("Đã bán")),
      DropdownMenuItem(value: false, child: Text("Chưa bán")),
      DropdownMenuItem(value: null, child: Text("Tất cả")),
    ],
    onChanged: onChanged,
  );
}

// Widget để hiển thị bộ lọc giá (minCost, maxCost)
Widget buildPriceRange({
  required double minPrice,
  required double maxPrice,
  required Function(RangeValues) onChanged,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Min: ${formatPrice(minPrice)}'),
          Text('Max: ${formatPrice(maxPrice)}'),
        ],
      ),
      RangeSlider(
        values: RangeValues(minPrice, maxPrice),
        min: 0,
        max: 200000000,
        divisions: 20,
        labels: RangeLabels('${formatPrice(minPrice)}', '${formatPrice(maxPrice)}'),
        onChanged: onChanged,
        activeColor: AppColors.primary,
        inactiveColor: Colors.grey[300],
      ),
    ],
  );
}

// Hàm định dạng giá trị thành tiền tệ
String formatPrice(double price) {
  return NumberFormat.currency(locale: 'vi_VN', symbol: '').format(price);
}

// Widget để hiển thị tiêu đề từng phần
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// Widget để hiển thị nút Đặt lại và Áp dụng
Widget buildBottomButtons({
  required VoidCallback onReset,
  required VoidCallback onApply,
}) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: onReset,
          child: const Text('Reset Filter'),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: ElevatedButton(
          onPressed: onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Apply'),
        ),
      ),
    ],
  );
}
