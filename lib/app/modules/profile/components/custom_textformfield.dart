import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  const CustomTextFormField({
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: false,
        contentPadding: EdgeInsets.zero,
        border: const UnderlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}
