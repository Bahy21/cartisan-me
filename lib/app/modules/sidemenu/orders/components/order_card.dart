import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/chat/components/chatroom_tile.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/dotted_line_divider.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/order_receipts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse?>(
      future: PostAPI().getPost(order.orderItems.first.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text('Error'),
          );
        }

        final post = snapshot.data!.post;
        final user = snapshot.data!.owner;

        var totalOrderItems = 0;
        for (final item in order.orderItems) {
          totalOrderItems += item.quantity;
        }
        final title = order.orderItems.length > 1
            ? post.productName
            : 'post.productNames & ${order.orderItems.length - 1} others';
        return Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.kGrey,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          post.images.first,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.productName,
                          style: AppTypography.kBold14,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Ordered from ${user.profileName}: ${howLongAgo(order.timestamp)}',
                          style: AppTypography.kExtraLight15.copyWith(
                            color: AppColors.kHintColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9.0.h),
              const DottedLineDivider(),
              SizedBox(height: 9.h),
              OrderReceipts(
                title: 'Price :',
                info: '\$${order.total} ',
                isPrice: true,
              ),
              SizedBox(
                height: 5.01.h,
              ),
              OrderReceipts(
                title: 'Quantity:',
                info: 'x$totalOrderItems',
              ),
              SizedBox(
                height: 5.0.h,
              ),
              OrderReceipts(
                title: 'Order Status :',
                info: order.orderStatus.name,
              ),
            ],
          ),
        );
      },
    );
  }
}
