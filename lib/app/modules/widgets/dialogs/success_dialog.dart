import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

Future<void> showSuccessDialogWithContext({
  required BuildContext context,
  required String message,
}) async {
  await ProgressDialog(
    context,
    type: ProgressDialogType.normal,
    isDismissible: false,
    showLogs: false,
    customBody: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/lottie/success.json',
          width: 100.w,
          height: 100.h,
          fit: BoxFit.fill,
          repeat: false,
        ),
        Text(
          'Success',
          style: AppTypography.kBold20.copyWith(color: Colors.green),
        ),
        SizedBox(height: 10.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.kLight12.copyWith(color: AppColors.kGrey),
        ),
        SizedBox(height: AppSpacing.twentyVertical),
        ElevatedButton(
          onPressed: () {
            hideSuccessDialogWithContext(context: context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            backgroundColor: Colors.green,
          ),
          child: Text('Continue', style: AppTypography.kLight14),
        ),
        SizedBox(
          height: AppSpacing.twentyVertical,
        ),
      ],
    ),
  ).show();
  return;
}

Future<bool> hideSuccessDialogWithContext({required BuildContext context}) {
  return ProgressDialog(context).hide();
}
