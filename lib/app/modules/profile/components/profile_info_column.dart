import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      children: [
        Text(numbers, style: AppTypography.kMedium18),
        Text(
          headings,
          style:
              AppTypography.kExtraLight15.copyWith(color: AppColors.kHintColor),
        ),
      ],
    );
  }
}
