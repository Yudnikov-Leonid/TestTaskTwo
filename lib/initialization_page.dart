import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:profile_app/di.dart';
import 'package:profile_app/widgets/q_button.dart';

import 'firebase_options.dart';

class InitializationPage extends StatefulWidget {
  const InitializationPage({required this.child, super.key});

  final Widget child;

  @override
  State<InitializationPage> createState() => _InitializationPageState();
}

class _InitializationPageState extends State<InitializationPage> {
  /// error
  /// true - loaded
  /// false - loading
  final _stream = StreamController<bool>();

  @override
  void initState() {
    _init();
    super.initState();
  }

  final _set = <String>{};

  Future _init() async {
    _stream.add(false);
    try {
      await _initItem('firebase', () async {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      });
      await _initItem('di', () async {
        await di.init();
      });
      await _initItem('crashlytics', () async {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      });
      await _initItem('other', () async {
        WidgetsFlutterBinding.ensureInitialized();
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
      _stream.add(true);
      Logger().i('successful init');
    } catch (e) {
      _stream.addError(e);
      Logger().e(e.toString(), error: e);
    }
  }

  Future _initItem(String name, Future Function() initItem,
      {bool isRequired = true}) async {
    if (_set.contains(name)) return;
    Logger().i('init $name');

    try {
      await initItem();
      _set.add(name);
    } catch (e) {
      if (isRequired) {
        rethrow;
      } else {
        _set.add(name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Initialization error:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text('${snapshot.error}'),
                  TextButton(
                      onPressed: () {},
                      child: QButton('Retry', () {
                        _init();
                      }))
                ],
              ),
            ));
          } else if (snapshot.data != true) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return widget.child;
          }
        });
  }
}
