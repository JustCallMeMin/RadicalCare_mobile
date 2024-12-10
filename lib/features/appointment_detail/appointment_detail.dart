import 'package:flutter/material.dart';
import '../../common/model/appointment.dart';
import '../../common/model/appointment_detail.dart';
import '../../common/utils/colors.dart';

import 'package:intl/intl.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsPage({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết phiếu đặt lịch',
          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Card(
                elevation: 4,
                color: AppColors.primaryBg,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin lịch hẹn',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'Trạng thái:',
                        _getVietnameseStatus(appointment.status),
                        color: _getStatusColor(appointment.status),
                      ),
                      _buildInfoRow(
                        'Ngày tạo:',
                        '${appointment.dateCreated.toLocal().toString().split(' ')[0]}',
                      ),
                      _buildInfoRow(
                        'Tổng chi phí:',
                        _formatCurrency(appointment.totalCost),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Chi tiết dịch vụ:',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appointment.details.length,
                itemBuilder: (context, index) {
                  final AppointmentDetail detail = appointment.details[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: AppColors.primaryBg,
                    shadowColor: AppColors.shadow,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(
                        Icons.miscellaneous_services,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      title: Text(
                        detail.serviceName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            detail.serviceDescription,
                            style: const TextStyle(color: AppColors.content, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ngày dịch vụ: ${detail.serviceDate.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(color: AppColors.content, fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Text(
                        _formatCurrency(detail.serviceCost),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.secondBg,
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: color ?? AppColors.content),
          ),
        ],
      ),
    );
  }

  String _getVietnameseStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Đang chờ xử lý';
      case 'Completed':
        return 'Hoàn thành';
      case 'Cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppColors.content;
    }
  }

  // Hàm định dạng số tiền
  String _formatCurrency(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'vi_VN', // Sử dụng định dạng tiền Việt Nam
      symbol: '₫', // Hiển thị ký hiệu tiền tệ
    );
    return formatter.format(amount);
  }
}

