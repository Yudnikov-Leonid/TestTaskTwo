import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/data/login_data.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginStateInitial()) {
    on<LoginEventChangeUiType>(onLoginEventChangeUiType);
  }

  LoginData _loginData = LoginData(
      uiType: LoginUiRegister(),
      email: '',
      password: '',
      name: '',
      confirmCode: '',
      restore: '');

  void onLoginEventChangeUiType(
      LoginEventChangeUiType event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith(uiType: event.newType);
    emit(LoginStateBase(loginData: _loginData, updateFields: true));
  }

  void onLoginEventInputEmail(LoginEventInputEmail event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith(email: event.email);
    emit(LoginStateBase(loginData: _loginData));
  }

  void onLoginEventInputPassword(LoginEventInputPassword event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith(password: event.password);
    emit(LoginStateBase(loginData: _loginData));
  }

  void onLoginEventInputName(LoginEventInputName event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith(name: event.name);
    emit(LoginStateBase(loginData: _loginData));
  }

  void onLoginEventInputConfirmCode(LoginEventInputConfirmCode event, Emitter<LoginState> emit) async {
    _loginData = _loginData.copyWith(confirmCode: event.confirmCode);
    emit(LoginStateBase(loginData: _loginData));
  }
}

/// EVENTS
abstract class LoginEvent {}

class LoginEventChangeUiType extends LoginEvent {
  final LoginUiType newType;

  LoginEventChangeUiType({required this.newType});
}

class LoginEventInputEmail extends LoginEvent {
  final String email;
  LoginEventInputEmail({required this.email});
}

class LoginEventInputPassword extends LoginEvent {
  final String password;
  LoginEventInputPassword({required this.password});
}

class LoginEventInputName extends LoginEvent {
  final String name;
  LoginEventInputName({required this.name});
}

class LoginEventInputConfirmCode extends LoginEvent {
  final String confirmCode;
  LoginEventInputConfirmCode({required this.confirmCode});
}

/// STATES
abstract class LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateBase extends LoginState {
  final LoginData loginData;
  /// обновлять поля ввода на значение из loginData
  /// по умолчанию false, чтобы не сеттить текст при каждой введённой букве, так как это портит опыт юзера
  final bool updateFields;

  LoginStateBase({required this.loginData, this.updateFields = false});
}
