import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Lottie.asset(
        'assets/lottie/loading.json',
        height: 150.h,
        width: 150.w,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    );
  }
}

void showLoadingDialog(BuildContext context, {bool dismissible = true}) {
  showDialog<void>(
    context: context,
    barrierDismissible: dismissible,
    builder: (_) => const LoadingDialog(),
  );
}

void hideLoadingDialog() {
  Get.back<void>();
}
