import 'package:cartisan/app/data/constants/app_assets.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EmptyPostMessage extends StatelessWidget {
  const EmptyPostMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppAssets.kNoPostIcon),
        SizedBox(
          height: 14.h,
        ),
        Text(
          'No Posts Yet',
          style: AppTypography.kBold18.copyWith(
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Text(
          'Looks like you have not posted \nanything yet.',
          style: AppTypography.kLight14.copyWith(
            color: AppColors.kLightGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
