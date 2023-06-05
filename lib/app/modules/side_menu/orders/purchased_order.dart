import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/purchase_history_controller.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/purchase_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchasedOrder extends StatelessWidget {
  const PurchasedOrder({super.key});
  String get currentUid => Get.find<AuthService>().currentUser!.uid;
  PurchaseHistoryController get pc => Get.find<PurchaseHistoryController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (pc.noPurchasesFound) {
        return const Center(
          child: Text('No purchases found'),
        );
      }
      if (pc.purchases.isEmpty) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return RefreshIndicator(
        onRefresh: () async {
          await pc.loadPurchasesFromApi();
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 13.h),
          itemCount: pc.purchases.length,
          padding: EdgeInsets.only(top: 20.h, left: 23.w, right: 23.0.w),
          itemBuilder: (context, index) {
            return PurchaseCard(
              orderIndex: index,
            );
          },
        ),
      );
    });
  }
}
