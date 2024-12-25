class BookingDetail {
  final int serviceId; // ID dịch vụ
  final String serviceDescription; // Mô tả dịch vụ
  final DateTime serviceDate; // Ngày thực hiện dịch vụ
  final double cost; // Chi phí dịch vụ

  BookingDetail({
    required this.serviceId,
    required this.serviceDescription,
    required this.serviceDate,
    required this.cost,
  });

  // Phương thức `fromJson` để tạo đối tượng từ JSON
  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      serviceId: json['serviceId'] ?? 0, // Gán giá trị mặc định nếu `serviceId` là null
      serviceDescription: json['serviceDescription'] ?? 'Unknown Service',
      serviceDate: DateTime.parse(json['serviceDate']), // Parse từ String sang DateTime
      cost: (json['cost'] ?? 0.0).toDouble(),
    );
  }

  // Phương thức `toJson` để chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceDescription': serviceDescription,
      'serviceDate': serviceDate.toIso8601String(), // Convert DateTime sang String
      'cost': cost,
    };
  }
}
