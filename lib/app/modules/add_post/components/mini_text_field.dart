import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  const MiniTextField({
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      focusNode: focusNode,
      decoration: InputDecoration(
        constraints: BoxConstraints(maxWidth: 153.w),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: const UnderlineInputBorder(),
        hintText: hintText,
        alignLabelWithHint: true,
      ),
    );
  }
}
