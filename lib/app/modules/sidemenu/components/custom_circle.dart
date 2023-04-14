import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircle extends StatelessWidget {
  final double size;
  const CustomCircle({
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Color(0xFFDA1457),
        shape: BoxShape.circle,
      ),
    );
  }
}
