import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class ProfileInfoColumn extends StatelessWidget {
  final String numbers;
  final String headings;
  const ProfileInfoColumn({
    required this.numbers,
    required this.headings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(numbers, style: AppTypography.kMedium16),
        Text(
          headings,
          style:
              AppTypography.kExtraLight13.copyWith(color: AppColors.kHintColor),
        ),
      ],
    );
  }
}
