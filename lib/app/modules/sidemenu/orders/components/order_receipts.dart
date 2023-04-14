import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class OrderReceipts extends StatelessWidget {
  final String title;
  final String info;
  final bool isPrice;
  const OrderReceipts({
    required this.title,
    required this.info,
    this.isPrice = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTypography.kExtraLight12),
        const Spacer(),
        Text(
          info,
          style: AppTypography.kMedium12
              .copyWith(color: isPrice ? AppColors.kPrimary : AppColors.kWhite),
        ),
      ],
    );
  }
}
