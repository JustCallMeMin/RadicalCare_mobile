class User {
  final String id;
  final String username;
  final String email;
  final String fullName;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] ?? 'No Name',
    );
  }
}