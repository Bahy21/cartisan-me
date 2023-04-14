import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartisanLogo extends StatelessWidget {
  const CartisanLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.h,
      width: 105.w,
      child: Image.asset(
        AppAssets.kCartisanLogo,
      ),
    );
  }
}
