class Vehicle {
  final String chassisNumber;
  final String vehicleName;
  final String version;
  final String color;
  final String segment;
  final List<String> imageUrls;
  final int categoryId;
  final bool isFavorite;
  final int costId;
  final double baseCost;
  final String description; // Thêm trường description

  Vehicle({
    required this.chassisNumber,
    required this.vehicleName,
    required this.version,
    required this.segment,
    required this.color,
    required this.imageUrls,
    required this.categoryId,
    this.isFavorite = false,
    required this.costId,
    this.baseCost = 0.0,
    required this.description, // Yêu cầu giá trị khi tạo đối tượng
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      chassisNumber: json['chassisNumber'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      version: json['version'] ?? '',
      segment: json['segment'] ?? '',
      color: json['color'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      categoryId: json['categoryId'] ?? -1,
      isFavorite: json['isFavorite'] ?? false,
      costId: json['costId'] ?? 0,
      baseCost: (json['cost'] ?? 0.0).toDouble(),
      description: json['description'] ?? '', // Lấy description từ JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chassisNumber': chassisNumber,
      'vehicleName': vehicleName,
      'version': version,
      'color': color,
      'segment': segment,
      'imageUrls': imageUrls,
      'categoryId': categoryId,
      'isFavorite': isFavorite,
      'costId': costId,
      'baseCost': baseCost,
      'description': description, // Đưa description vào JSON
    };
  }

  Vehicle copyWith({
    String? chassisNumber,
    String? vehicleName,
    String? version,
    String? color,
    String? segment,
    List<String>? imageUrls,
    int? categoryId,
    bool? isFavorite,
    int? costId,
    double? baseCost,
    String? description, // Cho phép cập nhật description
  }) {
    return Vehicle(
      chassisNumber: chassisNumber ?? this.chassisNumber,
      vehicleName: vehicleName ?? this.vehicleName,
      version: version ?? this.version,
      color: color ?? this.color,
      segment: segment ?? this.segment,
      imageUrls: imageUrls ?? this.imageUrls,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      costId: costId ?? this.costId,
      baseCost: baseCost ?? this.baseCost,
      description: description ?? this.description,
    );
  }
}
