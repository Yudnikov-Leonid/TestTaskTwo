import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_app/core/data/firestore_service.dart';
import 'package:profile_app/di.dart';
import 'package:profile_app/features/search/search_bloc.dart';
import 'package:profile_app/features/search/user_info_dialog.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(firestoreService: di.get<FirestoreService>())..add(SearchEventInitial()),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchStateMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SearchStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchStateFailure) {
            return Center(child: Text('Error is happened: ${state.message}'));
          } else if (state is SearchStateBase) {
            return _Body(state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body(this._data);

  final SearchStateBase _data;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _controller = TextEditingController();

  @override
  void initState() {
    if (widget._data.updateControllers) {
      _controller.text = widget._data.data.searchText;
    }
    super.initState();
  }

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final users = widget._data.data.users;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLength: 20,
            onChanged: (s) {
              context
                  .read<SearchBloc>()
                  .add(SearchEventInput(_controller.text));
            },
            decoration: InputDecoration(
                hintText: 'Search',
                counterText: '',
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchBloc>().add(SearchEventInput(''));
                          _focusNode.unfocus();
                        },
                        icon: const Icon(Icons.clear)))),
      ),
      body: users.isEmpty
          ? const Center(child: Text('Nothing found'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final user = users[i];
                return ListTile(
                    title: InkWell(
                  onTap: () {
                    FirebaseAnalytics.instance.logSelectContent(
                      contentType: 'user',
                      itemId: user.uid,
                      parameters: {
                        'email': FirebaseAuth.instance.currentUser?.email ?? 'null',
                        'uid': FirebaseAuth.instance.currentUser?.uid ?? 'null',
                      },
                    );
                    showDialog(
                        context: context,
                        builder: (context) => UserInfoDialog(user));
                  },
                  child: Row(children: [
                    user.iconPath == null
                        ? Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.grey),
                          )
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(user.iconPath!),
                          ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          child: Text(
                              user.description.isEmpty
                                  ? 'No description'
                                  : user.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                        ),
                      ],
                    )
                  ]),
                ));
              }),
    );
  }
}
