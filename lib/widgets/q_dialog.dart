import 'package:flutter/material.dart';

class QDialog extends StatelessWidget {
  const QDialog(this.title, this.desc, {super.key});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 16))
            ],
          )),
    );
  }
}
