class Booking {
  final String customerId; // ID khách hàng
  final DateTime date; // Ngày đặt lịch
  final List<int> serviceIds; // Danh sách ID dịch vụ

  Booking({
    required this.customerId,
    required this.date,
    required this.serviceIds,
  });

  // Phương thức `fromJson` để tạo đối tượng `Booking` từ JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      customerId: json['customerId'] ?? '',
      date: DateTime.parse(json['date']),
      serviceIds: List<int>.from(json['serviceIds']),
    );
  }

  // Phương thức `toJson` để chuyển đổi đối tượng `Booking` thành JSON
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      "dateCreated": date.toIso8601String().split('T')[0],
      'serviceIds': serviceIds,
    };
  }

  // Phương thức `copyWith` để tạo đối tượng mới với giá trị cập nhật
  Booking copyWith({
    String? customerId,
    DateTime? date,
    List<int>? serviceIds,
  }) {
    return Booking(
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      serviceIds: serviceIds ?? this.serviceIds,
    );
  }
}
