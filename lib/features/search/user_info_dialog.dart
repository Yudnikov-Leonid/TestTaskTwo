import 'package:flutter/material.dart';
import 'package:profile_app/core/data/user_entity.dart';

class UserInfoDialog extends StatelessWidget {
  const UserInfoDialog(this._user, {super.key});

  final UserEntity _user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      padding: const EdgeInsets.all(12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(_user.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        if (_user.iconPath != null)
          Image.network(_user.iconPath!, height: 400, width: 400, fit: BoxFit.cover)
        else
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: Colors.grey.shade300, shape: BoxShape.circle),
            child: const Icon(Icons.person, size: 140, color: Colors.grey),
          ),
        const SizedBox(height: 20),
        Text(
          _user.description.isEmpty ? 'No description' : _user.description,
          style: const TextStyle(color: Colors.grey),
        )
      ]),
    ));
  }
}
