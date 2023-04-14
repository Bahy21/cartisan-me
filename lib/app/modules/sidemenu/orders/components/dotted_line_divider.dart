import 'package:cartisan/app/data/constants/constants.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DottedLineDivider extends StatelessWidget {
  const DottedLineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const DottedLine(
      lineThickness: 2.0,
      dashColor: AppColors.kHintColor,
      dashLength: 5,
    );
  }
}
