import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/user_entity.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(SearchStateLoading()) {
    on<SearchEventInitial>(_onInitial);
    on<SearchEventInput>(onInput);
  }

  final FirestoreService _firestoreService;
  SearchData _data = SearchData(searchText: '', users: []);

  void onInput(SearchEventInput event, Emitter<SearchState> emit) async {
    final users = _firestoreService.getUsersList();
    _data = _data.copyWith(
        users: users.where((e) => e.name.toLowerCase().startsWith(event.input.toLowerCase())).toList(),
        searchText: event.input);
    emit(SearchStateBase(_data));
  }

  void _onInitial(SearchEventInitial event, Emitter<SearchState> emit) async {
    emit(SearchStateLoading());
    try {
      final streamIter = StreamIterator(_firestoreService.getUsersListYield());
      while (await streamIter.moveNext()) {
        _data = _data.copyWith(users: streamIter.current);
        emit(SearchStateBase(_data));
      }
    } catch (e) {
      emit(SearchStateFailure(e.toString()));
      emit(SearchStateBase(_data));
    }
  }
}

abstract class SearchEvent {}

class SearchEventInitial extends SearchEvent {}

class SearchEventInput extends SearchEvent {
  final String input;

  SearchEventInput(this.input);
}

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
