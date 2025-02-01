import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:profile_app/features/main_navigator/main_navigator.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(providers: [
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc()..add(LoginEventInitial()))
      ], child: const Scaffold(body: SafeArea(child: MainNavigator()))),
    );
  }
}
