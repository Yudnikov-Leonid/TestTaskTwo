class UserEntity {
  final String name;
  final String description;
  final String email;
  final String? iconPath;

  UserEntity(
      {required this.name,
      required this.description,
      required this.email,
      required this.iconPath});

  static UserEntity empty() {
    return UserEntity(name: '', description: '', email: '', iconPath: null);
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      iconPath: json['icon_path'],
    );
  }
}
