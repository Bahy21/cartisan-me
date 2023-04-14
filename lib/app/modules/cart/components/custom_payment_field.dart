import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomPaymentField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomPaymentField({
    required this.hintText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: false,
        hintText: hintText,
        hintStyle: AppTypography.kLight14.copyWith(color: AppColors.kGrey2),
      ),
    );
  }
}
