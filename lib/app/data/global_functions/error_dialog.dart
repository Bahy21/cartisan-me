import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    required this.message,
    this.showOkButton = true,
    Key? key,
  }) : super(key: key);
  final String message;
  final bool showOkButton;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      elevation: 0,
      title: Center(
        child: Text(
          'Error',
          style: AppTypography.kExtraBold20.copyWith(
            color: AppColors.kPrimary,
          ),
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.kWhite,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: <Widget>[
        if (showOkButton)
          TextButton(
            onPressed: () {
              Get.back<void>();
            },
            child: Text(
              'Ok',
              style: AppTypography.kLight15.copyWith(
                color: AppColors.kPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> showErrorDialog(String message) {
  return Get.dialog(ErrorDialog(
    message: message,
  ));
}

Future<void> showNoNetworkDialog() {
  return Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: const ErrorDialog(
        showOkButton: false,
        message: 'No internet connection',
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.75),
  );
}
