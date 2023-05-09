import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? radius;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.width,
    this.radius,
    super.key,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _tapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails _) {
    _controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: widget.onTap,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: 50.h,
          width: widget.width ?? 188.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.kPrimary,
            borderRadius: BorderRadius.circular(widget.radius ?? 10.r),
          ),
          child: Text(
            widget.text,
            style: AppTypography.kLight18.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
