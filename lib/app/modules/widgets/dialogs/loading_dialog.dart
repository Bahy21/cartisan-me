import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/modules/chat/components/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 50.h,
        maxWidth: 50.w,
      ),
      child: Center(
        child: Lottie.asset(
          'assets/lottie/loading.json',
          height: 150.h,
          width: 150.w,
          fit: BoxFit.fitHeight,
        ),
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
