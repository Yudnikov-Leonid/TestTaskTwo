import 'package:flutter/material.dart';
import 'package:profile_app/core/presentation/ui_validator.dart';

class EditFieldDialog extends StatefulWidget {
  const EditFieldDialog({
    required this.title,
    required this.text,
    required this.onSave,
    this.multiline = false,
    super.key,
  });

  final String title;
  final String text;
  final Function(String) onSave;
  final bool multiline;

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _controller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  keyboardType: widget.multiline ? TextInputType.multiline : null,
                  maxLines: widget.multiline ? null : 1,
                  controller: _controller,
                  validator: (value) =>
                      value == null ? null : EmptyUiValidator().isValid(value)),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          _isLoading = true;
                        });
                        if (_controller.text != widget.text) {
                          widget.onSave(_controller.text.trim());
                        }
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
