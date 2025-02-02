class UserEntity {
  final String name;
  final String desc;
  final String email;
  final String? iconPath;

  UserEntity(
      {required this.name,
      required this.desc,
      required this.email,
      required this.iconPath});

  static UserEntity empty() {
    return UserEntity(name: '', desc: '', email: '', iconPath: null);
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'] ?? '',
      desc: json['description'] ?? '',
      email: json['email'] ?? '',
      iconPath: json['icon_path'],
    );
  }
}
