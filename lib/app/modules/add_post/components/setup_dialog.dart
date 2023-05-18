import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetupDialog extends StatelessWidget {
  const SetupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.r),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Seller setup incomplete',
            style: AppTypography.kLight18,
          ),
          SizedBox(height: 10.h),
          Text(
            'Please complete your seller setup before you can create a product',
            style: AppTypography.kLight15,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 43.h),
          Row(
            children: [
              Text(
                '1. Setup Stripe',
                style: AppTypography.kLight14,
              ),
            ],
          ),
          SizedBox(height: 33.h),
          Row(
            children: [
              Text(
                '2. Add your state and tax info',
                style: AppTypography.kLight14,
              ),
              const Spacer(),
              const Icon(Icons.done),
            ],
          ),
          SizedBox(height: 78.h),
          PrimaryButton(
            onTap: () {
              Get.back<void>();
            },
            text: 'Finish Setup',
            width: 130.w,
          ),
        ],
      ),
    );
  }
}
