import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String name;
  final String description;
  final String email;
  final String? iconPath;

  const UserEntity(
      {required this.name,
      required this.description,
      required this.email,
      required this.iconPath});

  static UserEntity empty() {
    return const UserEntity(name: '', description: '', email: '', iconPath: null);
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      iconPath: json['icon_path'],
    );
  }

  @override
  List<Object?> get props => [name, description, email, iconPath];
}
