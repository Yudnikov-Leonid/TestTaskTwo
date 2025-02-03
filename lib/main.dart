import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:profile_app/features/main_navigator/main_navigator.dart';
import 'package:profile_app/initialization_page.dart';
import 'package:provider/provider.dart';
import 'di.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: InitializationPage(
          child: MultiProvider(providers: [
            BlocProvider<LoginBloc>(
                create: (context) =>
                    di.get<LoginBloc>()..add(LoginEventInitial()))
          ], child: const SafeArea(child: MainNavigator())),
        ),
      ),
    );
  }
}
