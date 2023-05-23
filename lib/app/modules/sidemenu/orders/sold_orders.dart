import 'dart:developer';

import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_card.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SoldOrders extends StatelessWidget {
  const SoldOrders({super.key});
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    log(currentUid);
    return FutureBuilder<List<OrderModel>>(
      future: OrderAPI().getSoldOrders(currentUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        }
        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return PurchaseCard(
              order: orders[index],
            );
          },
        );
      },
    );
  }
}
