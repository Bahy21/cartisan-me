import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String text;
  final bool value;
  final Function(bool) onChanged;
  final bool isDisabled;
  const CustomSwitch({
    required this.isDisabled,
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
          style: AppTypography.kExtraLight13.copyWith(
            color: value
                ? AppColors.kPrimary.withOpacity(isDisabled ? 0.5 : 1)
                : AppColors.kHintColor.withOpacity(isDisabled ? 0.5 : 1),
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.kPrimary.withOpacity(isDisabled ? 0.5 : 1),
          inactiveThumbColor: AppColors.kLightGrey,
          trackColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return AppColors.kWhite.withOpacity(isDisabled ? 0.5 : 1);
              }
              return AppColors.kWhite.withOpacity(isDisabled ? 0.5 : 1);
            },
          ),
          onChanged: isDisabled ? null : onChanged,
        ),
      ],
    );
  }
}
