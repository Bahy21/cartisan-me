// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/order_details_card.dart';
import 'package:cartisan/app/modules/side_menu/orders/components/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FullSaleDetails extends StatelessWidget {
  final int orderIndex;
  final Map<String, dynamic> posts;
  final UserModel buyer;
  const FullSaleDetails({
    required this.orderIndex,
    required this.posts,
    required this.buyer,
    super.key,
  });
  SalesHistoryController get sc => Get.find<SalesHistoryController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
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
                      'Order Details',
                      style: AppTypography.kExtraLight18,
                    ),
                    SizedBox(
                      height: AppSpacing.eightVertical,
                    ),
                    OrderDetailsCard(
                      orderId: sc.sales[orderIndex].orderId,
                      timestamp: sc.sales[orderIndex].timestamp,
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
                      addressModel: sc.sales[orderIndex].shippingAddress,
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
                              '(auto) ${orderItemStatusToString(sc.sales[orderIndex].orderStatus)}',
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
                        return OrderItemCard(
                          orderItemIndex: index,
                          orderIndex: orderIndex,
                          itemIndex: index,
                          product: (posts[sc.sales[orderIndex].orderItems[index]
                                  .orderItemID] as PostResponse)
                              .post,
                          buyer: buyer,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10.w,
                      ),
                      itemCount: sc.sales[orderIndex].orderItems.length,
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
