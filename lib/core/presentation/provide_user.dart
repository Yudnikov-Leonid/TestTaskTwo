import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/user_entity.dart';
import 'package:profile_app/di.dart';

class ProvideUser extends StatefulWidget {
  const ProvideUser({required this.child, super.key});

  final Widget child;

  @override
  State<ProvideUser> createState() => ProvideUserState();
}

class ProvideUserState extends State<ProvideUser> {
  final _firestoreService = di.get<FirestoreService>();
  late UserEntity user;
  final _streamController = StreamController<UserEntity>();
  late Stream<UserEntity> userStream;
  late StreamSubscription _sub;

  @override
  void initState() {
    userStream = _streamController.stream;
    _sub = _firestoreService.userStream().listen((newUser) {
      //user = UserEntity.fromJson(newUser.data()!);
      //_streamController.add(user);
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future _loadUser() async {
    user = await _firestoreService.getUser();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return widget.child;
        }
    );
  }
}
