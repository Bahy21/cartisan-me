import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StoreFacilityColumn extends StatelessWidget {
  final String iconPath;
  final String text;
  final bool isAvailable;
  const StoreFacilityColumn({
    required this.iconPath,
    required this.text,
    this.isAvailable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          iconPath,
          color: isAvailable ? AppColors.kPrimary : AppColors.kHintColor,
        ),
        SizedBox(height: 5.h),
        Text(
          text,
          style: AppTypography.kMedium14.copyWith(
            color: isAvailable ? AppColors.kPrimary : AppColors.kHintColor,
          ),
        ),
      ],
    );
  }
}
