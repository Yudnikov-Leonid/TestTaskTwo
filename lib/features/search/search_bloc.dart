import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/user_entity.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required FirestoreService firestoreService})
      : _firestoreService = firestoreService,
        super(const SearchStateLoading()) {
    on<SearchEventInitial>(_onInitial);
    on<SearchEventInput>(onInput);
  }

  final FirestoreService _firestoreService;
  SearchData _data = const SearchData(searchText: '', users: []);

  void onInput(SearchEventInput event, Emitter<SearchState> emit) async {
    final users = _firestoreService.getUsersList();
    try {
      _data = _data.copyWith(
          users: users.where((e) => e.name.toLowerCase().startsWith(event.input.toLowerCase())).toList(),
          searchText: event.input);

    } catch (e) {
      emit(SearchStateMessage(e.toString()));
    }
    emit(SearchStateBase(_data));
  }

  void _onInitial(SearchEventInitial event, Emitter<SearchState> emit) async {
    emit(const SearchStateLoading());
    try {
      final iter = StreamIterator(_firestoreService.getUsersListYield());
      while (await iter.moveNext()) {
        _data = _data.copyWith(users: iter.current);
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

abstract class SearchState extends Equatable {
  const SearchState();
}

class SearchStateLoading extends SearchState {
  const SearchStateLoading();

  @override
  List<Object?> get props => [];
}

class SearchStateFailure extends SearchState {
  final String message;

  const SearchStateFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchStateMessage extends SearchState {
  final String message;

  const SearchStateMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchStateBase extends SearchState {
  final SearchData data;
  final bool updateControllers;

  const SearchStateBase(this.data, {this.updateControllers = false});

  @override
  List<Object?> get props => [data, updateControllers];
}

class SearchData extends Equatable {
  final String searchText;
  final List<UserEntity> users;

  const SearchData({required this.searchText, required this.users});

  SearchData copyWith({String? searchText, List<UserEntity>? users}) {
    return SearchData(
        searchText: searchText ?? this.searchText, users: users ?? this.users);
  }

  @override
  List<Object?> get props => [searchText, users];
}
