import 'package:radicalcare/common/model/vehicle_model.dart';

class CartItem {
  final String id; // ID của CartItem
  final String chassisNumber; // Mã số khung của xe
  final Vehicle vehicle; // Chi tiết xe
  final int quantity; // Số lượng
  final double subtotal; // Tổng giá trị của mục giỏ hàng

  CartItem({
    required this.id,
    required this.chassisNumber,
    required this.vehicle,
    required this.quantity,
    required this.subtotal,
  });

  /// Getter tính toán subtotal từ baseCost và quantity, sử dụng nếu không có sẵn subtotal từ backend
  double get calculatedSubtotal => vehicle.baseCost * quantity;

  /// Factory method từ JSON, ánh xạ dữ liệu API vào object `CartItem`
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      chassisNumber: json['vehicle']['chassisNumber'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle']),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    );
  }

  /// Chuyển `CartItem` thành JSON để gửi API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle': {
        'chassisNumber': chassisNumber,
      },
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  /// Sao chép object `CartItem` với các giá trị được cập nhật
  CartItem copyWith({
    String? id,
    String? chassisNumber,
    Vehicle? vehicle,
    int? quantity,
    double? subtotal,
  }) {
    return CartItem(
      id: id ?? this.id,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      vehicle: vehicle ?? this.vehicle,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  /// Override toString để hỗ trợ log dữ liệu
  @override
  String toString() {
    return 'CartItem(id: $id, chassisNumber: $chassisNumber, vehicle: ${vehicle.vehicleName}, quantity: $quantity, subtotal: $subtotal)';
  }
}
