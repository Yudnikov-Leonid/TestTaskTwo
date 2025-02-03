import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/storage_service.dart';
import 'package:profile_app/core/data/user_entity.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  late final StreamSubscription _sub;

  ProfileBloc(
      {required StorageService storageService,
      required FirestoreService firestoreService})
      : _storageService = storageService,
        _firestoreService = firestoreService,
        super(const ProfileStateLoading()) {
    _sub = _firestoreService.userStream().listen((newUser) {
      _user = newUser;
      add(ProfileEventUpdate());
    });

    on<ProfileEventLoadImage>(onLoadImage);
    on<ProfileEventSaveName>(onSaveName);
    on<ProfileEventSaveDescription>(onSaveDescription);
    on<ProfileEventUpdate>(onUpdate);
    on<ProfileEventInitial>(onInitial);
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }

  final StorageService _storageService;
  final FirestoreService _firestoreService;
  late UserEntity _user;

  void onSaveName(
      ProfileEventSaveName event, Emitter<ProfileState> emit) async {
    try {
      await _firestoreService.setName(event.name);
    } catch (e) {
      emit(ProfileStateMessage(e.toString()));
    }
    emit(ProfileStateBase(_user));
  }

  void onSaveDescription(
      ProfileEventSaveDescription event, Emitter<ProfileState> emit) async {
    try {
      await _firestoreService.setDescription(event.description);
    } catch (e) {
      emit(ProfileStateMessage(e.toString()));
    }
    emit(ProfileStateBase(_user));
  }

  void onUpdate(ProfileEventUpdate event, Emitter<ProfileState> emit) async {
    emit(ProfileStateBase(_user));
  }

  void onInitial(ProfileEventInitial event, Emitter<ProfileState> emit) async {
    emit(const ProfileStateLoading());
    try {
      final stream = StreamIterator(_firestoreService.getUserYield());
      while (await stream.moveNext()) {
        _user = stream.current;
        emit(ProfileStateBase(_user));
      }
    } catch (e) {
      emit(ProfileStateMessage(e.toString()));
      emit(ProfileStateBase(_user));
    }
  }

  void onLoadImage(
      ProfileEventLoadImage event, Emitter<ProfileState> emit) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(const ProfileStateLoading());
      final result = await _storageService.loadImage(image);
      if (result.$2) {
        await _firestoreService.setImageUrl(result.$1!);
        emit(ProfileStateBase(_user));
      } else {
        emit(ProfileStateMessage(result.$1 ?? 'Error is happened'));
        emit(ProfileStateBase(_user));
      }
    } catch (e) {
      emit(ProfileStateMessage(e.toString()));
      emit(ProfileStateBase(_user));
    }
  }
}

abstract class ProfileEvent {}

class ProfileEventInitial extends ProfileEvent {}

class ProfileEventUpdate extends ProfileEvent {}

class ProfileEventSaveName extends ProfileEvent {
  final String name;

  ProfileEventSaveName(this.name);
}

class ProfileEventSaveDescription extends ProfileEvent {
  final String description;

  ProfileEventSaveDescription(this.description);
}

class ProfileEventLoadImage extends ProfileEvent {}

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileStateLoading extends ProfileState {
  const ProfileStateLoading();

  @override
  List<Object?> get props => [];
}

class ProfileStateMessage extends ProfileState {
  final String message;

  const ProfileStateMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileStateBase extends ProfileState {
  final UserEntity user;

  const ProfileStateBase(this.user);

  @override
  List<Object?> get props => [user];
}
