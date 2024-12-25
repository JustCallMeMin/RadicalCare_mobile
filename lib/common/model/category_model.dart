class Category {
  final int id;
  final String name;
  final int warrantyInfoId;

  Category({
    required this.id,
    required this.name,
    required this.warrantyInfoId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      warrantyInfoId: json['warrantyInfoId'],
    );
  }
}
