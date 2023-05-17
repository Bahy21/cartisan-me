import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoPictures extends StatelessWidget {
  const NoPictures({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30.h,
        ),
        Icon(
          Icons.filter_rounded,
          size: 160.h,
          color: Colors.grey.shade300,
        ),
        Text(
          'No posts to show',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
