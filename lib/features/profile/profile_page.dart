import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/core/data/storage_service.dart';
import 'package:profile_app/di.dart';
import 'package:profile_app/features/login/presentation/login_bloc.dart';
import 'package:profile_app/features/profile/edit_field_dialog.dart';
import 'package:profile_app/features/profile/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _bloc;

  @override
  void initState() {
    _bloc = ProfileBloc(
        storageService: di.get<StorageService>(),
        firestoreService: di.get<FirestoreService>())..add(ProfileEventInitial());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _bloc,
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileStateBase) {
            return _Body(state, _bloc);
          }
          return const SizedBox();
        }));
  }
}

class _Body extends StatelessWidget {
  const _Body(this._state, this._bloc);

  final ProfileStateBase _state;
  final ProfileBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  StorageServiceImpl().loadImage(image);
                }
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300, shape: BoxShape.circle),
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => EditFieldDialog(
                            title: 'Edit name',
                            text: _state.user.name,
                            onSave: (value) {
                              _bloc.add(ProfileEventSaveName(value));
                            }));
                  },
                  child: Text(_state.user.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => EditFieldDialog(
                            title: 'Edit description',
                            text: _state.user.description,
                            multiline: true,
                            onSave: (value) {
                              _bloc.add(ProfileEventSaveDescription(value));
                            }));
                  },
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: Text(
                          _state.user.description.isEmpty
                              ? 'No description'
                              : _state.user.description,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey))),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('press on element to edit',
              style: TextStyle(color: Colors.grey.shade700)),
        ),
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text('Actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        ),
        TextButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginEventLogout());
            },
            style: TextButton.styleFrom(
                shape: const LinearBorder(),
                alignment: Alignment.centerLeft,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50)),
            child: const Text('Log out'))
      ]),
    );
  }
}
