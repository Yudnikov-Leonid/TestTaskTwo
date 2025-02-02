import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/user_entity.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(SearchStateLoading()) {
    on<SearchEventInitial>(_onInitial);
  }

  final FirestoreService _firestoreService;
  SearchData _data = SearchData(searchText: '', users: []);

  void _onInitial(SearchEventInitial event, Emitter<SearchState> emit) async {
    emit(SearchStateLoading());
    try {
      final users = await _firestoreService.getUsersList();
      _data = _data.copyWith(users: users);
    } catch (e) {
      emit(SearchStateFailure(e.toString()));
    }
    emit(SearchStateBase(_data));
  }
}

abstract class SearchEvent {}

class SearchEventInitial extends SearchEvent {}

abstract class SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateFailure extends SearchState {
  final String message;
  SearchStateFailure(this.message);
}

class SearchStateMessage extends SearchState {
  final String message;

  SearchStateMessage(this.message);
}

class SearchStateBase extends SearchState {
  final SearchData data;
  final bool updateControllers;

  SearchStateBase(this.data, {this.updateControllers = false});
}

class SearchData {
  final String searchText;
  final List<UserEntity> users;

  SearchData({required this.searchText, required this.users});

  SearchData copyWith({String? searchText, List<UserEntity>? users}) {
    return SearchData(
        searchText: searchText ?? this.searchText, users: users ?? this.users);
  }
}
