import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/core/constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool alignLabelWithHint;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.validator,
    this.alignLabelWithHint = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: alignLabelWithHint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: validator,
      ),
    );
  }
}
