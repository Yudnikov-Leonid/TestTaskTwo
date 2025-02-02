import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profile_app/features/login/presentation/login_page.dart';
import 'package:profile_app/features/profile/profile_page.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.data?.emailVerified ?? false) {
            return const ProfilePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
