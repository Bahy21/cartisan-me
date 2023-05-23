import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.kFilledColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h),
            child: SvgPicture.asset(
              AppAssets.kSearch,
              height: 16.h,
              width: 16.w,
            ),
          ),
          SizedBox(
            width: 7.5.w,
          ),
          Text(
            'Search',
            style: AppTypography.kExtraLight15
                .copyWith(color: AppColors.kHintColor),
          ),
        ],
      ),
    );
  }
}
