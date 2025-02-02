import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/data/login_data.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:profile_app/widgets/q_button.dart';
import 'package:profile_app/widgets/q_dialog.dart';

import '../../../core/presentation/ui_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _registrationFormKey = GlobalKey<FormState>();
  final _authFormKey = GlobalKey<FormState>();
  final _restoreFormKey = GlobalKey<FormState>();

  void _updateControllers(LoginData data) {
    _emailController.text = data.email;
    _passwordController.text = data.password;
    _nameController.text = data.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginStateMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
      if (state is LoginStateDialog) {
        showDialog(
            context: context,
            builder: (context) => QDialog(state.title, state.message));
      }
    }, builder: (context, state) {
      if (state is LoginStateLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is LoginStateBase) {
        if (state.updateControllers) {
          _updateControllers(state.loginData);
        }
        final uiType = state.loginData.uiType;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              const Text('Profile App', style: TextStyle(fontSize: 30)),
              const Expanded(child: SizedBox()),
              if (uiType is LoginUiRegister)
                _registration()
              else if (uiType is LoginUiAuth)
                _auth()
              else if (uiType is LoginUiRestore)
                _restore(),
              const Expanded(child: SizedBox()),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _registration() {
    return Form(
      key: _registrationFormKey,
      child: Column(
        children: [
          _emailTextField(),
          _passwordTextField(),
          _nameTextField(),
          const SizedBox(height: 20),
          QButton('Register', () {
            if (!_registrationFormKey.currentState!.validate()) return;
            context.read<LoginBloc>().add(LoginEventRegister());
          }),
          const SizedBox(height: 40),
          _changeTypeButton('Have an account?', LoginUiAuth())
        ],
      ),
    );
  }

  Widget _auth() {
    return Form(
      key: _authFormKey,
      child: Column(
        children: [
          _emailTextField(),
          _passwordTextField(),
          const SizedBox(height: 20),
          QButton('Login', () {
            if (!_authFormKey.currentState!.validate()) return;
            context.read<LoginBloc>().add(LoginEventAuth());
          }),
          const SizedBox(height: 40),
          _changeTypeButton('Don\'t have an account?', LoginUiRegister()),
          _changeTypeButton('Restore password', LoginUiRestore())
        ],
      ),
    );
  }

  Widget _restore() {
    return Form(
      key: _restoreFormKey,
      child: Column(
        children: [
          _emailTextField(),
          const SizedBox(height: 20),
          QButton('Send code', () {
            if (!_restoreFormKey.currentState!.validate()) return;
            context.read<LoginBloc>().add(LoginEventRestore());
          }),
          const SizedBox(height: 40),
          _changeTypeButton('Go back', LoginUiAuth()),
        ],
      ),
    );
  }

  Widget _changeTypeButton(String text, LoginUiType uiType) {
    return TextButton(
        onPressed: () {
          context
              .read<LoginBloc>()
              .add(LoginEventChangeUiType(newType: uiType));
        },
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
        child: Text(text, style: TextStyle(color: Colors.blue.shade600)));
  }

  final _emailValidator = EmptyUiValidator(next: EmailUiValidator());

  Widget _emailTextField() {
    return _textField(
      _emailController,
      'Email',
      validation: (s) => s == null ? null : _emailValidator.isValid(s),
      (text) {
        context.read<LoginBloc>().add(LoginEventInputEmail(email: text));
      },
    );
  }

  final _passwordValidator = EmptyUiValidator(next: LengthUiValidator(6));

  Widget _passwordTextField() {
    return _textField(
      _passwordController,
      'Password',
      validation: (s) => s == null ? null : _passwordValidator.isValid(s),
      isPassword: true,
      (text) {
        context.read<LoginBloc>().add(LoginEventInputPassword(password: text));
      },
    );
  }

  final _nameValidator = EmptyUiValidator(next: LengthUiValidator(4));

  Widget _nameTextField() {
    return _textField(
      _nameController,
      'Name',
      validation: (s) => s == null ? null : _nameValidator.isValid(s),
      (text) {
        context.read<LoginBloc>().add(LoginEventInputName(name: text));
      },
    );
  }

  Widget _textField(TextEditingController controller, String hint,
      Function(String) onTextChanged,
      {bool isPassword = false, String? Function(String?)? validation}) {
    return TextFormField(
      validator: validation,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      onChanged: onTextChanged,
    );
  }
}
