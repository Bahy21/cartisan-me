import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/dotted_line_divider.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_card.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_receipts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurchasedOrder extends StatelessWidget {
  const PurchasedOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 13.h),
      itemCount: 3,
      padding: EdgeInsets.only(top: 20.h, left: 23.w, right: 23.0.w),
      itemBuilder: (context, index) {
        return const OrderCard();
      },
    );
  }
}
