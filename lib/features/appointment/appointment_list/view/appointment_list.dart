import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/utils/colors.dart';
import '../../appointment_detail/appointment_detail.dart';
import '../provider/appointment_list_notifier.dart';

class AppointmentListPage extends ConsumerWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAppointments = ref.watch(appointmentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách phiếu đặt lịch',
          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryBg,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              print('Refresh button clicked. Invalidating appointment list provider...');
              ref.invalidate(appointmentListNotifierProvider);
            },
          ),
        ],
        iconTheme: const IconThemeData(color: AppColors.primary),
        elevation: 0,
      ),
      body: asyncAppointments.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stack) => Center(
          child: Text(
            'Không thể tải dữ liệu: $error',
            style: const TextStyle(color: AppColors.unchecked),
          ),
        ),
        data: (appointments) => appointments.isEmpty
            ? const Center(
          child: Text(
            'Hiện tại không có phiếu đặt lịch nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        )
            : ListView.separated(
          itemCount: appointments.length,
          separatorBuilder: (context, index) => Divider(color: AppColors.content),
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.primaryBg,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.calendar_today, color: AppColors.primaryBg),
                ),
                title: Text(
                  'Ngày đặt: ${appointment.dateCreated.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  _getVietnameseStatus(appointment.status),
                  style: TextStyle(
                    color: _getStatusColor(appointment.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.secondary),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AppointmentDetailsPage(appointment: appointment),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      backgroundColor: AppColors.secondBg,
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
}
