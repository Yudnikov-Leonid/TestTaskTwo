import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:synchronized/synchronized.dart';

DI di = DI();

class DI {
  final _container = <Type, dynamic>{};

  Future init() async {
    _container.addAll({
      Lock: Lock(),
    });

    _container
        .addAll({FirestoreService: FirestoreServiceImpl(_container[Lock])});

    _container.addAll({
      LoginBloc: LoginBloc(
        firestoreService: _container[FirestoreService],
      )
    });
  }

  T get<T>() => _container[T];
}
