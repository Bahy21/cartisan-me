import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  ErrorDialog({
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
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
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
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
      child: ErrorDialog(
        showOkButton: false,
        message: 'No internet connection',
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.75),
  );
}
