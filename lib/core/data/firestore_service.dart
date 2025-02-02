import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:profile_app/core/data/user_entity.dart';
import 'package:synchronized/synchronized.dart';

abstract class FirestoreService {
  Future createUser(UserCreateData data);

  Future<UserEntity> getUser();

  Stream<UserEntity> userStream();

  Future setName(String name);

  Future setDescription(String description);

  Future setImageUrl(String url);

  Future<List<UserEntity>> getUsersList();
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
  Stream<UserEntity> userStream() {
    final userRef = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return userRef.snapshots().map((e) => UserEntity.fromJson(e.data()!));
  }

  @override
  Future<UserEntity> getUser() => _lock.synchronized(() async {
        final data = await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (data.data() == null) {
          return UserEntity.empty();
        }
        return UserEntity.fromJson(data.data()!);
      });

  @override
  Future setDescription(String description) => _lock.synchronized(() async {
        final userRef = _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        await userRef.update({'description': description});
      });

  @override
  Future setName(String name) => _lock.synchronized(() async {
        final userRef = _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        await userRef.update({'name': name});
      });

  @override
  Future setImageUrl(String url) => _lock.synchronized(() async {
    final userRef = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await userRef.update({'icon_path': url});
  });

  List<UserEntity> _usersCache = [];
  @override
  Future<List<UserEntity>> getUsersList() async {
    if (_usersCache.isEmpty) {
      final data = await _firestore.collection('users').get();
      _usersCache = data.docs.map((e) => UserEntity.fromJson(e.data())).toList();
    }
    return _usersCache;
  }
}

class UserCreateData {
  final String name;
  final String email;

  UserCreateData({required this.name, required this.email});
}
