import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool) onChanged;
  const CustomSwitch({
    required this.text,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppTypography.kExtraLight12.copyWith(
            color: value?AppColors.kPrimary:AppColors.kHintColor,
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.kPrimary,
          inactiveThumbColor: AppColors.kLightGrey,
          trackColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors.kWhite;
              }
              return AppColors.kWhite;
            },
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
