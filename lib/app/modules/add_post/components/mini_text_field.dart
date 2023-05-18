import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MiniTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  const MiniTextField({
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
