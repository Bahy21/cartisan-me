// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FullOrderDetails extends StatelessWidget {
  final int orderIndex;
  final Map<String, dynamic> posts;
  final UserModel buyer;
  const FullOrderDetails({
    required this.orderIndex,
    required this.posts,
    required this.buyer,
    super.key,
  });
  OrderModel get order => Get.find<SalesHistoryController>().sales[orderIndex];
  @override
  Widget build(BuildContext context) {
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
                  orderId: order.orderId,
                  timestamp: order.timestamp,
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
                  addressModel: order.shippingAddress,
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
                        child: Text('(auto) ${order.orderStatus.name}'),
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
                      product: (posts[order.orderItems[index].orderItemID]
                              as PostResponse)
                          .post,
                      buyer: buyer,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10.w,
                  ),
                  itemCount: order.orderItems.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
