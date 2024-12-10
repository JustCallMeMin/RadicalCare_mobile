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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date Created: ${dateCreated.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Status: $status', style: const TextStyle(fontSize: 14)),
              Text('Customer ID: $customerId', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              const Text(
                'Services:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        detail.serviceName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Description: ${detail.serviceDescription}\n'
                            'Service Date: ${detail.serviceDate.toLocal()}',
                      ),
                      trailing: Text(
                        '\$${detail.serviceCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
