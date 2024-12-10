import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/booking_notifier.dart';

class ServiceSelectorWidget extends ConsumerStatefulWidget {
  const ServiceSelectorWidget({Key? key}) : super(key: key);

  @override
  _ServiceSelectorWidgetState createState() => _ServiceSelectorWidgetState();
}

class _ServiceSelectorWidgetState extends ConsumerState<ServiceSelectorWidget> {
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
              value: selectedServiceId,
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
                    selectedServiceId = selectedId;
                    ref.read(bookingNotifierProvider.notifier).addOrUpdateServiceDetail(
                      serviceId: selectedId,
                      serviceDate: DateTime.now(),
                      serviceDescription: services.firstWhere((s) => s['serviceId'] == selectedId)['serviceDescription'],
                      cost: 100.0, // Thay bằng giá thực tế từ backend
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: ref.watch(bookingNotifierProvider).serviceIds.map((serviceId) {
                final service = services.firstWhere((s) => s['serviceId'] == serviceId);
                return Chip(
                  label: Text(service['serviceName'] ?? "Unknown"),
                  onDeleted: () {
                    ref.read(bookingNotifierProvider.notifier).removeServiceDetail(serviceId);
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
