import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/data/login_data.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginStateInitial()) {
    on<LoginEventInitial>(onLoginEventInitial);
    on<LoginEventChangeUiType>(onLoginEventChangeUiType);

    on<LoginEventInputEmail>(onLoginEventInputEmail);
    on<LoginEventInputPassword>(onLoginEventInputPassword);
    on<LoginEventInputName>(onLoginEventInputName);
    on<LoginEventInputConfirmCode>(onLoginEventInputConfirmCode);

    on<LoginEventRegister>(onLoginEventRegister);
    on<LoginEventAuth>(onLoginEventAuth);
    on<LoginEventRestore>(onLoginEventRestore);
  }

  LoginData _data = LoginData(
      uiType: LoginUiRegister(),
      email: '',
      password: '',
      name: '',
      confirmCode: '',
      restore: '');

  void onLoginEventRegister(
      LoginEventRegister event, Emitter<LoginState> emit) async {}

  void onLoginEventAuth(LoginEventAuth event, Emitter<LoginState> emit) async {}

  void onLoginEventRestore(
      LoginEventRestore event, Emitter<LoginState> emit) async {}

  void onLoginEventInitial(
      LoginEventInitial event, Emitter<LoginState> emit) async {
    emit(LoginStateBase(_data, updateControllers: true));
  }

  void onLoginEventChangeUiType(
      LoginEventChangeUiType event, Emitter<LoginState> emit) async {
    _data = _data.copyWith(uiType: event.newType);
    emit(LoginStateBase(_data, updateControllers: true));
  }

  void onLoginEventInputEmail(
      LoginEventInputEmail event, Emitter<LoginState> emit) async {
    _data = _data.copyWith(email: event.email);
    emit(LoginStateBase(_data));
  }

  void onLoginEventInputPassword(
      LoginEventInputPassword event, Emitter<LoginState> emit) async {
    _data = _data.copyWith(password: event.password);
    emit(LoginStateBase(_data));
  }

  void onLoginEventInputName(
      LoginEventInputName event, Emitter<LoginState> emit) async {
    _data = _data.copyWith(name: event.name);
    emit(LoginStateBase(_data));
  }

  void onLoginEventInputConfirmCode(
      LoginEventInputConfirmCode event, Emitter<LoginState> emit) async {
    _data = _data.copyWith(confirmCode: event.confirmCode);
    emit(LoginStateBase(_data));
  }
}

/// EVENTS
abstract class LoginEvent {}

class LoginEventInitial extends LoginEvent {}

class LoginEventAuth extends LoginEvent {}

class LoginEventRestore extends LoginEvent {}

class LoginEventRegister extends LoginEvent {}

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

class LoginStateLoading extends LoginState {}

class LoginStateMessage extends LoginState {
  final String message;

  LoginStateMessage({required this.message});
}

class LoginStateBase extends LoginState {
  final LoginData loginData;

  /// обновлять поля ввода на значение из loginData
  /// по умолчанию false, чтобы не сеттить текст при каждой введённой букве, так как это портит опыт юзера
  final bool updateControllers;

  LoginStateBase(this.loginData, {this.updateControllers = false});
}
