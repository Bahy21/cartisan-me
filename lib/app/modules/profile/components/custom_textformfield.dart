import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final double? textPaddingFromTop;
  const CustomTextFormField({
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.textPaddingFromTop,
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
        contentPadding: textPaddingFromTop == null
            ? EdgeInsets.zero
            : EdgeInsets.only(top: textPaddingFromTop!),
        border: const UnderlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}
