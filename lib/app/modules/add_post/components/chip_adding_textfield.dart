import 'package:flutter/material.dart';

class ProductVariantField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? addIcon;
  final FocusNode? focusNode;
  const ProductVariantField({
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.addIcon,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        suffixIcon: addIcon,
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: const UnderlineInputBorder(),
        hintText: hintText,
        alignLabelWithHint: true,
      ),
    );
  }
}
