import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/booking_notifier.dart';

class ServiceSelectorWidget extends ConsumerStatefulWidget {
  const ServiceSelectorWidget({Key? key}) : super(key: key);

  @override
  _ServiceSelectorWidgetState createState() => _ServiceSelectorWidgetState();
}

class _ServiceSelectorWidgetState extends ConsumerState<ServiceSelectorWidget> {
  // Giá trị được chọn trong dropdown
  int? selectedServiceId;

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(motorServicesProvider);

    return servicesAsync.when(
      data: (services) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedServiceId, // Đảm bảo `value` có giá trị trong `items`
              items: services.map<DropdownMenuItem<int>>((service) {
                return DropdownMenuItem<int>(
                  value: service['serviceId'],
                  child: Text(service['serviceName'] ?? "Unknown Service"),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Chọn dịch vụ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (selectedId) {
                if (selectedId != null) {
                  setState(() {
                    selectedServiceId = selectedId; // Cập nhật `value` được chọn
                    ref.read(bookingNotifierProvider.notifier).addServiceId(selectedId);
                  });
                }
              },
            ),
            SizedBox(height: 10),
            // Hiển thị danh sách các dịch vụ đã chọn
            Wrap(
              spacing: 8.0,
              children: ref.watch(bookingNotifierProvider).serviceIds.map((serviceId) {
                final service = services.firstWhere((s) => s['serviceId'] == serviceId);
                return Chip(
                  label: Text(service['serviceName'] ?? "Unknown"),
                  onDeleted: () {
                    setState(() {
                      ref.read(bookingNotifierProvider.notifier).removeServiceId(serviceId);
                      if (selectedServiceId == serviceId) {
                        selectedServiceId = null; // Xóa giá trị nếu khớp với `value`
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text("Failed to load services: $error"),
      ),
    );
  }
}
