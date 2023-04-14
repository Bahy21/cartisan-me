import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/components/custom_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: AppColors.kPrimary),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            left: -33,
            top: 33,
            child: CustomCircle(
              size: 77.h,
            ),
          ),
          Positioned(
            top: -23,
            left: 50,
            child: CustomCircle(
              size: 52.h,
            ),
          ),
          Positioned(
            top: 23,
            left: 80,
            child: CustomCircle(
              size: 88.h,
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: CustomCircle(
              size: 88.0.h,
            ),
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: CustomCircle(
              size: 87.0.h,
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: CustomCircle(
              size: 21.h,
            ),
          ),
          Positioned(
            bottom: 30,
            right: 80,
            child: CustomCircle(
              size: 28.h,
            ),
          ),
          Positioned(
            bottom: -20,
            left: 40,
            child: CustomCircle(
              size: 40.h,
            ),
          ),
        ],
      ),
    );
  }
}
