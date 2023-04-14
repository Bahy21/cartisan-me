import 'package:cartisan/app/modules/sidemenu/orders/components/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoldOrders extends StatelessWidget {
  const SoldOrders({super.key});

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
