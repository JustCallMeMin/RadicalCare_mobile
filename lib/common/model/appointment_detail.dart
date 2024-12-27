class AppointmentDetail {
  final int id; // ID của chi tiết
  final int appointmentId; // ID của phiếu đặt lịch
  final int serviceId; // ID dịch vụ
  final String serviceName; // Tên dịch vụ
  final String serviceDescription; // Mô tả dịch vụ
  final DateTime serviceDate; // Ngày thực hiện dịch vụ
  final double serviceCost; // Chi phí dịch vụ

  AppointmentDetail({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceDate,
    required this.serviceCost,
  });

  // Parse từ JSON
  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
      id: json['id'],
      appointmentId: json['appointmentId'] ?? 0,
      serviceId: json['serviceId'] ?? 0,
      serviceName: json['serviceName'] ?? 'Unknown Service',
      serviceDescription: json['serviceDescription'] ?? 'No Description',
      serviceDate: DateTime(
        json['serviceDate'][0], // Năm
        json['serviceDate'][1], // Tháng
        json['serviceDate'][2], // Ngày
      ),
      serviceCost: (json['serviceCost'] ?? 0.0).toDouble(),
    );
  }

  // Convert thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'serviceDate': [serviceDate.year, serviceDate.month, serviceDate.day], // Mảng ngày
      'serviceCost': serviceCost,
    };
  }

  // Thêm hàm `copyWith` để dễ dàng sao chép với các giá trị thay đổi
  AppointmentDetail copyWith({
    int? id,
    int? appointmentId,
    int? serviceId,
    String? serviceName,
    String? serviceDescription,
    DateTime? serviceDate,
    double? serviceCost,
  }) {
    return AppointmentDetail(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceCost: serviceCost ?? this.serviceCost,
    );
  }
}
