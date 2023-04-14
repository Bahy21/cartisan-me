import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color? color;
  final Color? btnColor;
  final Color? fontColor;
  const CustomOutlinedButton({
    required this.onTap,
    required this.text,
    this.btnColor,
    this.color,
    this.fontColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 30.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: btnColor,
            border: Border.all(color: color ?? AppColors.kWhite),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTypography.kMedium14.copyWith(
                color: fontColor ?? AppColors.kWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
