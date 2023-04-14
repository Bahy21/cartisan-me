import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAddressTextField extends StatelessWidget {
  final String heading;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  const CustomAddressTextField({
    required this.heading,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: AppTypography.kMedium16,
        ),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          validator: validator,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTypography.kMedium14,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            hintStyle:
                AppTypography.kMedium14.copyWith(color: AppColors.kHintColor),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.kWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
