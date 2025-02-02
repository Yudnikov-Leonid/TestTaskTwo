import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synchronized/synchronized.dart';

abstract class FirestoreService {
  Future createUser(UserCreateData data);
}

class FirestoreServiceImpl implements FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final Lock _lock;

  FirestoreServiceImpl(this._lock);

  @override
  Future createUser(UserCreateData data) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).set({
      'name': data.name,
      'email': data.email,
      'icon_path': null,
      'description': ''
    });
  }
}

class UserCreateData {
  final String name;
  final String email;

  UserCreateData(
      {required this.name, required this.email});
}
