import 'package:flutter/material.dart';
import 'package:radicalcare/common/model/appointment.dart';
import '../../../../../common/model/booking.dart';
import '../../../../../common/model/appointment_detail.dart';
import 'appointment_details.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final List<AppointmentDetail> details;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.details, // Thêm danh sách chi tiết dịch vụ
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('Date: ${appointment.dateCreated.toLocal().toString().split(' ')[0]}'),
        subtitle: Text(
          'Status: ${appointment.status}\nCustomer: ${appointment.customerId}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to appointment details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetails(
                customerId: appointment.customerId,
                status: appointment.status,
                dateCreated: appointment.dateCreated,
                details: details, // Truyền danh sách chi tiết dịch vụ
              ),
            ),
          );
        },
      ),
    );
  }
}
