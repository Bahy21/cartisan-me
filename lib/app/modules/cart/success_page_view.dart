import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/landingPage/landing_page.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccessPageView extends StatelessWidget {
  const SuccessPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Lottie.asset(
            'assets/lottie/success.json',
            repeat: false,
          ),
          Text(
            'Success',
            style: AppTypography.kBold24,
          ),
          SizedBox(height: 8.h),
          Text(
            'Thank you for shopping using Cartisan',
            style: AppTypography.kExtraLight15
                .copyWith(color: AppColors.kHintColor),
          ),
          SizedBox(height: 35.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: PrimaryButton(
              onTap: () {
                Get.offAll<Widget>(() => const LandingPage());
              },
              text: 'Back to Order',
              width: double.maxFinite,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
