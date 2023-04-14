import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomStepper extends StatefulWidget {
  List<bool> statuses;

  CustomStepper({
    required this.statuses,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 33.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...List.generate(4, (index) {
            if (index == (4 - 1)) {
              return SizedBox(
                height: 24.h,
                width: 24.w,
                child:
                    CustomSteps(active: widget.statuses[index], isLast: true),
              );
            }
            return Expanded(child: CustomSteps(active: widget.statuses[index]));
          }),
        ],
      ),
    );
  }
}

class CustomSteps extends StatelessWidget {
  final bool active;
  final bool isLast;
  const CustomSteps({
    required this.active,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 24.h,
          width: 24.w,
          decoration: BoxDecoration(
            color: active ? AppColors.kPrimary : AppColors.kGrey2,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.done, size: 14),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              height: 4.h,
              width: 105.w,
              color: active ? AppColors.kPrimary : AppColors.kGrey2,
            ),
          ),
      ],
    );
  }
}
