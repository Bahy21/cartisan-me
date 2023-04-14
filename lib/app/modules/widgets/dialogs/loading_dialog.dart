import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 95.w),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
        ),
        content: Lottie.asset('assets/lottie/loading.json',height: 100.h,width: 100.w,fit: BoxFit.cover),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const LoadingDialog(),
  );
}

void hideLoadingDialog() {
  Get.back<void>();
}
