import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/features/login/data/login_data.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required FirestoreService firestoreService,
  })  : _firestoreService = firestoreService,
        super(LoginStateLoading()) {
    on<LoginEventInitial>(onLoginEventInitial);
    on<LoginEventChangeUiType>(onLoginEventChangeUiType);

    on<LoginEventInputEmail>(onLoginEventInputEmail);
    on<LoginEventInputPassword>(onLoginEventInputPassword);
    on<LoginEventInputName>(onLoginEventInputName);

    on<LoginEventRegister>(onLoginEventRegister);
    on<LoginEventAuth>(onLoginEventAuth);
    on<LoginEventRestore>(onLoginEventRestore);
    on<LoginEventLogout>(onLoginEventLogout);
  }

  final FirestoreService _firestoreService;

  LoginData _data = LoginData(
      uiType: LoginUiRegister(),
      email: '',
      password: '',
      name: '',
      restore: '');

  void onLoginEventRegister(
      LoginEventRegister event, Emitter<LoginState> emit) async {
    try {
      emit(LoginStateLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _data.email, password: _data.password);
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await _firestoreService
          .createUser(UserCreateData(name: _data.name, email: _data.email));
      await FirebaseAuth.instance.signOut();

      emit(LoginStateDialog('Link to verify is sent', 'Check your email'));
      _data = _data.copyWith(uiType: LoginUiAuth(), email: '', name: '');
    } on FirebaseAuthException catch (e, st) {
      print('e: ${e.message}, st: $st');
      if (e.code == 'weak-password') {
        emit(LoginStateMessage('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(LoginStateMessage('The account already exists for that email.'));
      } else {
        emit(LoginStateMessage(e.message ?? ''));
      }
    } catch (e, st) {
      print('e: $e, st: $st');
      emit(LoginStateMessage(e.toString()));
    }
    emit(LoginStateBase(_data, updateControllers: true));
  }

  void onLoginEventAuth(LoginEventAuth event, Emitter<LoginState> emit) async {
    if (_data.email.isEmpty || _data.password.isEmpty) {
      emit(LoginStateMessage('All fields must not be empty'));
      emit(LoginStateBase(_data));
      return;
    }

    try {
      emit(LoginStateLoading());
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _data.email, password: _data.password);
      if (cred.user?.emailVerified ?? false) {
        _data = _data.copyWith(
            uiType: LoginUiRegister(),
            email: '',
            password: '',
            name: '',
            restore: '');
      } else {
        await FirebaseAuth.instance.signOut();
        emit(LoginStateMessage('Verify your email'));
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginStateMessage(e.message ?? ''));
    } catch (e, st) {
      print('e: $e, st: $st');
      emit(LoginStateMessage(e.toString()));
    }
    emit(LoginStateBase(_data));
  }

  void onLoginEventRestore(
      LoginEventRestore event, Emitter<LoginState> emit) async {
    if (_data.email.isEmpty) {
      emit(LoginStateMessage('All fields must not be empty'));
      emit(LoginStateBase(_data));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _data.email);
      emit(LoginStateDialog('Link is sent', 'Check your email'));
      _data = _data.copyWith(uiType: LoginUiAuth());
    } on FirebaseAuthException catch (e) {
      emit(LoginStateMessage(e.message ?? ''));
    } catch (e) {
      emit(LoginStateMessage(e.toString()));
    }
    emit(LoginStateBase(_data));
  }

  void onLoginEventLogout(
      LoginEventLogout event, Emitter<LoginState> emit) async {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

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
}

/// EVENTS
abstract class LoginEvent {}

class LoginEventInitial extends LoginEvent {}

class LoginEventAuth extends LoginEvent {}

class LoginEventRestore extends LoginEvent {}

class LoginEventRegister extends LoginEvent {}

class LoginEventLogout extends LoginEvent {}

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

/// STATES
abstract class LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateMessage extends LoginState {
  final String message;

  LoginStateMessage(this.message);
}

class LoginStateDialog extends LoginState {
  final String title;
  final String message;

  LoginStateDialog(this.title, this.message);
}

class LoginStateBase extends LoginState {
  final LoginData loginData;

  /// обновлять поля ввода на значение из loginData
  /// по умолчанию false, чтобы не сеттить текст при каждой введённой букве, так как это портит опыт юзера
  final bool updateControllers;

  LoginStateBase(this.loginData, {this.updateControllers = false});
}
