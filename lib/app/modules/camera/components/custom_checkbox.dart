// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckBox extends StatelessWidget {
  final String heading;
  final bool value;
  final Function(bool?) onChanged;
  const CustomCheckBox({
    required this.heading,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(heading, style: AppTypography.kLight14),
        const Spacer(),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.kPrimary,
          side: BorderSide(width: 1.w, color: AppColors.kWhite),
        ),
        Text('Select', style: AppTypography.kLight14),
      ],
    );
  }
}
