
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

Future<void> showErrorDialogWithContext({
  required BuildContext context,
  required String message,
}) async {
  final twentyPixelsVertical = AppSpacing.twentyVertical;

  await ProgressDialog(
    context,
    type: ProgressDialogType.normal,
    isDismissible: false,
    showLogs: false,
    customBody: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/lottie/error.json',
          width: 100.w,
          height: 100.h,
          fit: BoxFit.fill,
          repeat: false,
        ),
        Text('Error', style: AppTypography.kBold20.copyWith(color: Colors.red)),
        SizedBox(height: 10.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.kLight12.copyWith(color: AppColors.kGrey),
        ),
        SizedBox(height: twentyPixelsVertical),
        ElevatedButton(
          onPressed: () => hideErrorDialogWithContext(context: context),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            backgroundColor: Colors.red,
          ),
          child: Text(
            'Ok',
            style: AppTypography.kLight14,
          ),
        ),
        SizedBox(height: twentyPixelsVertical),
      ],
    ),
  ).show();
  return;
}

Future<bool> hideErrorDialogWithContext({required BuildContext context}) {
  return ProgressDialog(context).hide();
}
