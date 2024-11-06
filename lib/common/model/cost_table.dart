class CostTable {
  final int costId;
  final double baseCost;
  final String dateCreate;
  final bool isDeleted;

  CostTable({
    required this.costId,
    required this.baseCost,
    required this.dateCreate,
    required this.isDeleted,
  });

  // Phương thức fromJson để tạo đối tượng CostTable từ JSON
  factory CostTable.fromJson(Map<String, dynamic> json) {
    return CostTable(
      costId: json['costId'],
      baseCost: json['baseCost'].toDouble(), // Đảm bảo baseCost là double
      dateCreate: json['dateCreate'],
      isDeleted: json['isDeleted'],
    );
  }
}
