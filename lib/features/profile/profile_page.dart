import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/core/data/user_entity.dart';
import 'package:profile_app/core/presentation/provide_user.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserEntity _user;
  late StreamSubscription _sub;

  @override
  void initState() {
    final state = context.findAncestorStateOfType<ProvideUserState>()!;
    _user = state.user;
    _sub = state.userStream.listen((newUser) {
      setState(() {
        _user = newUser;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_user.name,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: Text(
                        _user.desc.isEmpty ? 'No description' : _user.desc,
                        style: const TextStyle(fontSize: 14, color: Colors.grey))),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('press on element to edit',
              style: TextStyle(color: Colors.grey.shade700)),
        ),
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text('Actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        ),
        TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginEventLogout());
            },
            style: TextButton.styleFrom(
                shape: const LinearBorder(),
                alignment: Alignment.centerLeft,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text('Log out'))
      ]),
    );
  }
}
