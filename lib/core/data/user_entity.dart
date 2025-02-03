import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String description;
  final String email;
  final String? iconPath;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.description,
    required this.email,
    required this.iconPath,
  });

  static UserEntity empty() {
    return const UserEntity(
        uid: '', name: '', description: '', email: '', iconPath: null);
  }

  factory UserEntity.fromJson(Map<String, dynamic> json, String uid) {
    return UserEntity(
      uid: uid,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      email: json['email'] ?? '',
      iconPath: json['icon_path'],
    );
  }

  @override
  List<Object?> get props => [name, description, email, iconPath];
}
