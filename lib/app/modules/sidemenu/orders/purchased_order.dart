import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchasedOrder extends StatelessWidget {
  const PurchasedOrder({super.key});
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: OrderAPI().getPurchasedOrders(currentUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        }
        final orders = snapshot.data!;

        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 13.h),
          itemCount: orders.length,
          padding: EdgeInsets.only(top: 20.h, left: 23.w, right: 23.0.w),
          itemBuilder: (context, index) {
            return OrderCard(
              order: orders[index],
            );
          },
        );
      },
    );
  }
}
