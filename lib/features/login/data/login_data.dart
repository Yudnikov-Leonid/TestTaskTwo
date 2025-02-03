import 'package:equatable/equatable.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';

class LoginData extends Equatable {
  final LoginUiType uiType;
  final String email;
  final String password;
  final String name;
  final String restore;

  const LoginData({
    required this.uiType,
    required this.email,
    required this.password,
    required this.name,
    required this.restore,
  });

  LoginData copyWith({
    LoginUiType? uiType,
    String? email,
    String? password,
    String? name,
    String? restore,
  }) {
    return LoginData(
      uiType: uiType ?? this.uiType,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      restore: restore ?? this.restore,
    );
  }

  @override
  List<Object?> get props => [uiType, email, password, name, restore];
}
