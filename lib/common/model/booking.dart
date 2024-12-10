class Booking {
  final String customerId; // ID khách hàng
  final DateTime dateCreated; // Ngày tạo lịch hẹn
  final List<int> serviceIds; // Danh sách ID dịch vụ

  Booking({
    required this.customerId,
    required this.dateCreated, // Lưu dưới dạng DateTime
    required this.serviceIds,
  });

  // Phương thức `fromJson` để tạo đối tượng `Appointment` từ JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      customerId: json['customerId'] ?? '',
      dateCreated: DateTime.parse(json['dateCreated']), // Parse từ String sang DateTime
      serviceIds: List<int>.from(json['serviceIds']),
    );
  }

  // Phương thức `toJson` để chuyển đổi đối tượng `Appointment` thành JSON
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'dateCreated': dateCreated.toIso8601String(), // Convert DateTime sang String
      'serviceIds': serviceIds,
    };
  }

  // Phương thức `copyWith` để tạo đối tượng mới với giá trị cập nhật
  Booking copyWith({
    String? customerId,
    DateTime? dateCreated,
    List<int>? serviceIds,
  }) {
    return Booking(
      customerId: customerId ?? this.customerId,
      dateCreated: dateCreated ?? this.dateCreated,
      serviceIds: serviceIds ?? this.serviceIds,
    );
  }
}
