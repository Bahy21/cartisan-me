import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart' as ok;

void showToast(
  String message,
) {
  ok.showToastWidget(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.kFilledColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: ColoredBox(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(7.5.w),
                child: Image.asset(
                  AppAssets.kCartisanLogo,
                  color: AppColors.kPrimary,
                  height: 22.5.w,
                  width: 22.5.w,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: AppTypography.kLight15.copyWith(color: AppColors.kWhite),
          ),
        ],
      ),
    ),
    position: ok.ToastPosition.bottom,
  );
}
