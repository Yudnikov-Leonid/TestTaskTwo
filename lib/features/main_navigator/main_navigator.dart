import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profile_app/features/login/presentation/login_page.dart';
import 'package:profile_app/features/profile/profile_page.dart';
import 'package:profile_app/features/search/search_page.dart';

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
            return const _BottomNavigator();
          } else {
            return const LoginPage();
          }
        });
  }
}

class _BottomNavigator extends StatefulWidget {
  const _BottomNavigator();

  @override
  State<_BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<_BottomNavigator> {
  int _index = 0;
  final _pages = [const SearchPage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
      body: _pages[_index],
    );
  }
}
