import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/widgets/buttons/custom_text_button.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeleteCartItemDialog extends StatelessWidget {
  final VoidCallback deleteConfirmationCallback;
  const DeleteCartItemDialog({
    required this.deleteConfirmationCallback,
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
            'Delete this item from your cart?',
            style: AppTypography.kLight18,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Get.back<void>();
                },
                child: Text(
                  'Cancel',
                  style: AppTypography.kMedium16.copyWith(
                    color: AppColors.kHintColor,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              ElevatedButton(
                onPressed: deleteConfirmationCallback,
                child: Text(
                  'Yes, Delete it',
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
