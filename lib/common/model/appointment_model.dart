import 'appointment_detail.dart';

class Appointment {
  final int id; // ID của phiếu đặt lịch
  final String customerId; // ID khách hàng
  final DateTime dateCreated; // Ngày tạo phiếu
  final String status; // Trạng thái của phiếu
  final List<AppointmentDetail> details; // Danh sách chi tiết phiếu
  late final double totalCost; // Tổng chi phí, tính toán từ details

  Appointment({
    required this.id,
    required this.customerId,
    required this.dateCreated,
    required this.status,
    required this.details,
  }) {
    // Tính toán tổng chi phí tại thời điểm khởi tạo
    totalCost = _calculateTotalCost();
  }

  // Hàm tính toán tổng chi phí từ danh sách chi tiết
  double _calculateTotalCost() {
    return details.fold(0.0, (sum, detail) => sum + detail.serviceCost);
  }

  // Parse từ JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      customerId: json['customerId'] as String? ?? '',
      dateCreated: DateTime(
        json['dateCreated'][0], // Năm
        json['dateCreated'][1], // Tháng
        json['dateCreated'][2], // Ngày
      ),
      status: json['status'] as String? ?? 'Pending',
      details: (json['details'] as List<dynamic>)
          .map((detailJson) => AppointmentDetail.fromJson(detailJson as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'dateCreated': [dateCreated.year, dateCreated.month, dateCreated.day], // Mảng ngày
      'status': status,
      'details': details.map((detail) => detail.toJson()).toList(),
      'totalCost': totalCost, // Tổng chi phí
    };
  }

  // Hàm copy để tạo một bản sao với các giá trị thay đổi
  Appointment copyWith({
    int? id,
    String? customerId,
    DateTime? dateCreated,
    String? status,
    List<AppointmentDetail>? details,
  }) {
    return Appointment(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      dateCreated: dateCreated ?? this.dateCreated,
      status: status ?? this.status,
      details: details ?? this.details,
    );
  }
}
