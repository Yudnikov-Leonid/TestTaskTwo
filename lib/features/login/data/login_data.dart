import 'package:profile_app/features/login/data/login_ui_type.dart';

class LoginData {
  final LoginUiType uiType;
  final String email;
  final String password;
  final String name;
  final String confirmCode;
  final String restore;

  LoginData({
    required this.uiType,
    required this.email,
    required this.password,
    required this.name,
    required this.confirmCode,
    required this.restore,
  });

  LoginData copyWith({
    LoginUiType? uiType,
    String? email,
    String? password,
    String? name,
    String? confirmCode,
    String? restore,
  }) {
    return LoginData(
      uiType: uiType ?? this.uiType,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      confirmCode: confirmCode ?? this.confirmCode,
      restore: restore ?? this.restore,
    );
  }
}
