import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductOptionDialog extends StatelessWidget {
  final VoidCallback reportCallback;
  const ProductOptionDialog({
    required this.reportCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 35.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'What do you want ?',
            style: AppTypography.kLight18,
          ),
          SizedBox(height: 34.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Get.back<void>();
                },
                child: Text(
                  'Cancel',
                  style: AppTypography.kMedium16.copyWith(color: AppColors.kWhite),
                ),
              ),
              SizedBox(width: 20.w),
              ElevatedButton(
                onPressed: reportCallback,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(14.h),
                ),
                child: Text(
                  'Report Product',
                  style: AppTypography.kMedium16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
