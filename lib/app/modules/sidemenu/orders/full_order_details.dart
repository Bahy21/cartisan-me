// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullOrderDetails extends StatelessWidget {
  final OrderModel order;
  final Map<String, dynamic> posts;
  final UserModel buyer;
  const FullOrderDetails({
    required this.order,
    required this.posts,
    required this.buyer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              OrderDetailsCard(
                orderId: order.orderId,
                timestamp: order.timestamp,
              ),
              SizedBox(
                height: 10.h,
              ),
              AddressCard(
                addressModel: order.shippingAddress,
              ),
              SizedBox(
                height: AppSpacing.seventeenHorizontal,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return OrderItemCard(
                    orderItem: order.orderItems[index],
                    order: order,
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
      padding: EdgeInsets.only(left: 13.w, right: 13.0.w, top: 19.h),
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
          Text(
            'Ordered At: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}',
            style: AppTypography.kExtraLight12,
          ),
        ],
      ),
    );
  }
}
