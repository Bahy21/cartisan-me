import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtherStoreFacilityCard extends StatelessWidget {
  final String text;
  final bool isAvailable;
  const OtherStoreFacilityCard({
    required this.text,
    required this.isAvailable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isAvailable)
          const Icon(Icons.done, color: AppColors.kPrimary)
        else
          SvgPicture.asset(
            AppAssets.kCancel,
          ),
        SizedBox(
          width: 10.w,
        ),
        Text(text, style: AppTypography.kMedium14.copyWith(color: Colors.grey)),
      ],
    );
  }
}
