import 'package:flutter/material.dart';

/// q - чтобы основной набор виджетовов было легко найти

class QButton extends StatelessWidget {
  const QButton(this.text, this.action, {super.key});

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
        child: Text(text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
  }
}
