import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummaryCard extends StatelessWidget {
  final String serviceFee;
  final String deliveryCost;
  final String taxAmount;
  const OrderSummaryCard({
    required this.serviceFee,
    required this.deliveryCost,
    required this.taxAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Fee',
                style: AppTypography.kMedium12,
              ),
              Text(
                serviceFee,
                style: AppTypography.kMedium12,
              ),
            ],
          ),
          const Divider(
            color: AppColors.kHintColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Cost',
                style: AppTypography.kMedium12,
              ),
              Text(
                deliveryCost,
                style: AppTypography.kMedium12,
              ),
            ],
          ),
          const Divider(
            color: AppColors.kHintColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax Amount',
                style: AppTypography.kMedium12,
              ),
              Text(
                taxAmount,
                style: AppTypography.kMedium12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
