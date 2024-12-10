import 'package:flutter/material.dart';
import '../../../../../common/model/appointment_detail.dart';

class AppointmentDetails extends StatelessWidget {
  final String customerId; // ID khách hàng
  final String status; // Trạng thái lịch hẹn
  final DateTime dateCreated; // Ngày tạo lịch hẹn
  final List<AppointmentDetail> details; // Danh sách chi tiết dịch vụ

  const AppointmentDetails({
    Key? key,
    required this.customerId,
    required this.status,
    required this.dateCreated,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Created: ${dateCreated.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Status: $status'),
            Text('Customer ID: $customerId'),
            const SizedBox(height: 16),
            const Text(
              'Services:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...details.map((AppointmentDetail detail) {
              return ListTile(
                title: Text(detail.serviceDescription),
                subtitle: Text('Service Date: ${detail.serviceDate}'),
                trailing: Text('\$${detail.cost.toStringAsFixed(2)}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
