import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderDetailsCard extends StatelessWidget {
  final String orderId;
  final int timestamp;
  const OrderDetailsCard({
    required this.orderId,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 19.h),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: $orderId',
            style: AppTypography.kMedium16,
          ),
          SizedBox(
            height: AppSpacing.sixVertical,
          ),
          Text(
            'Ordered At: ${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(timestamp))} @ ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp))}',
            style: AppTypography.kExtraLight12,
          ),
        ],
      ),
    );
  }
}
