import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profile_app/core/data/user_entity.dart';
import 'package:synchronized/synchronized.dart';

abstract class FirestoreService {
  Future createUser(UserCreateData data);
  Future<UserEntity> getUser();
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream();
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

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() {
    final userRef = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    return userRef.snapshots();
  }

  @override
  Future<UserEntity> getUser() async {
    final data = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (data.data() == null) {
      return UserEntity.empty();
    }
    return UserEntity.fromJson(data.data()!);
  }
}

class UserCreateData {
  final String name;
  final String email;

  UserCreateData(
      {required this.name, required this.email});
}
