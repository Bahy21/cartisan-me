import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  const SearchField({ required this.controller, this.onSubmitted,super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        style: AppTypography.kExtraLight15,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Search',
          contentPadding: EdgeInsets.zero,
          hintStyle:
              AppTypography.kExtraLight15.copyWith(color: AppColors.kHintColor),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.h),
            child: SvgPicture.asset(
              AppAssets.kSearch,
              height: 16.h,
              width: 16.w,
            ),
          ),
        ),
      ),
    );
  }
}
