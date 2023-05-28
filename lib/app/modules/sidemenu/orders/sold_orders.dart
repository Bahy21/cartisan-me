import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/full_sale_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SoldOrders extends StatelessWidget {
  const SoldOrders({super.key});
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  SalesHistoryController get sc => Get.find<SalesHistoryController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (sc.noSalesFound) {
          return const Center(
            child: Text('No orders found'),
          );
        }
        if (sc.sales.isEmpty) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await sc.loadSalesFromApi();
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 13.h),
            itemCount: sc.sales.length,
            padding: EdgeInsets.only(top: 20.h, left: 23.w, right: 23.0.w),
            itemBuilder: (context, index) {
              return FullSaleCard(
                order: sc.sales[index],
              );
            },
          ),
        );
      },
    );
  }
}
