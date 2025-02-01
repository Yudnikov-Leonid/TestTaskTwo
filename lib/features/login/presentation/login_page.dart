import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/data/login_data.dart';
import 'package:profile_app/features/login/data/login_ui_type.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:profile_app/widgets/q_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginBloc _bloc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    _bloc = LoginBloc()..add(LoginEventInitial());
    super.initState();
  }

  void _updateControllers(LoginData data) {
    _emailController.text = data.email;
    _passwordController.text = data.password;
    _nameController.text = data.name;
    _confirmController.text = data.confirmCode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
        if (state is LoginStateMessage) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
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
                else if (uiType is LoginUiConfirm)
                  _confirm()
                else if (uiType is LoginUiRestore)
                  _restore(),
                const Expanded(child: SizedBox()),
              ],
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget _registration() {
    return Column(
      children: [
        _emailTextField(),
        _passwordTextField(),
        _nameTextField(),
        const SizedBox(height: 20),
        QButton('Register', () {}),
        const SizedBox(height: 40),
        _changeTypeButton('Have an account?', LoginUiAuth())
      ],
    );
  }

  Widget _auth() {
    return Column(
      children: [
        _emailTextField(),
        _passwordTextField(),
        const SizedBox(height: 20),
        QButton('Login', () {}),
        const SizedBox(height: 40),
        _changeTypeButton('Don\'t have an account?', LoginUiRegister()),
        _changeTypeButton('Restore password', LoginUiRestore())
      ],
    );
  }

  Widget _confirm() {
    return Column(
      children: [
        _confirmTextField(),
      ],
    );
  }

  Widget _restore() {
    return Column(
      children: [
        _emailTextField(),
        const SizedBox(height: 20),
        QButton('Send code', () {}),
        const SizedBox(height: 40),
        _changeTypeButton('Go back', LoginUiAuth()),
      ],
    );
  }

  Widget _changeTypeButton(String text, LoginUiType uiType) {
    return TextButton(
        onPressed: () {
          _bloc.add(LoginEventChangeUiType(newType: uiType));
        },
        style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
        child: Text(text, style: TextStyle(color: Colors.blue.shade600)));
  }

  Widget _emailTextField() {
    return _textField(_emailController, 'Email');
  }

  Widget _passwordTextField() {
    return _textField(_passwordController, 'Password');
  }

  Widget _nameTextField() {
    return _textField(_nameController, 'Name');
  }

  Widget _confirmTextField() {
    return _textField(_confirmController, 'Confirm');
  }

  Widget _textField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      controller: controller,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
