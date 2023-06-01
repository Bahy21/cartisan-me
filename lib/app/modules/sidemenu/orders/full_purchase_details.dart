// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/modules/sidemenu/orders/components/order_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cartisan/app/controllers/purchase_detail_controller.dart';
import 'package:cartisan/app/controllers/purchase_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/purchased_item_card.dart';

class FullPurchaseDetails extends StatelessWidget {
  final int orderIndex;
  const FullPurchaseDetails({
    required this.orderIndex,
    super.key,
  });
  PurchaseHistoryController get pc => Get.find<PurchaseHistoryController>();
  @override
  Widget build(BuildContext context) {
    return GetX<PurchaseDetailController>(
      init:
          PurchaseDetailController(orderToBeFetched: pc.purchases[orderIndex]),
      builder: (controller) {
        if (controller.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        return SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.kFilledColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purchase Details',
                      style: AppTypography.kExtraLight18,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    OrderDetailsCard(
                      orderId: pc.purchases[orderIndex].orderId,
                      timestamp: pc.purchases[orderIndex].timestamp,
                    ),
                    const Divider(
                      color: AppColors.kWhite,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    Text(
                      'Shipping Address',
                      style: AppTypography.kExtraLight18,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    AddressCard(
                      addressModel: pc.purchases[orderIndex].shippingAddress,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    const Divider(
                      color: AppColors.kWhite,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Item(s)',
                          style: AppTypography.kExtraLight18,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: Text(
                              '(auto) ${orderItemStatusToString(pc.purchases[orderIndex].orderStatus)}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final post = controller.posts[pc.purchases[orderIndex]
                            .orderItems[index].orderItemID] as PostResponse;
                        return PurchasedItemCard(
                          orderItemIndex: index,
                          orderIndex: orderIndex,
                          product: post.post,
                          seller: post.owner,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10.w,
                      ),
                      itemCount: controller.order.orderItems.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
