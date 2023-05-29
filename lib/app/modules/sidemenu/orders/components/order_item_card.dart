import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/cancel_and_refund_button.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/change_order_status_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderItemCard extends StatefulWidget {
  final int orderIndex;
  final int orderItemIndex;
  final PostModel product;
  final UserModel buyer;
  final bool sellerMode;
  final bool isCheckout;
  final int itemIndex;
  const OrderItemCard({
    required this.orderItemIndex,
    required this.orderIndex,
    required this.itemIndex,
    required this.product,
    required this.buyer,
    Key? key,
    this.sellerMode = false,
    this.isCheckout = false,
  }) : super(key: key);

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  OrderModel get order =>
      Get.find<SalesHistoryController>().sales[widget.orderIndex];
  OrderItemModel get orderItem => order.orderItems[widget.orderItemIndex];

  bool get cancelable =>
      orderItem.status == OrderItemStatus.awaitingFulfillment &&
      !widget.isCheckout;

  bool get isEditable => [
        OrderItemStatus.awaitingFulfillment,
        OrderItemStatus.awaitingShipment,
        OrderItemStatus.shipped,
        OrderItemStatus.awaitingPickup,
      ].contains(orderItem.status);
  bool get showStatus => ![
        OrderItemStatus.pending,
        OrderItemStatus.awaitingPayment,
      ].contains(orderItem.status);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: widget.product.images.first,
              width: 50.w,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              errorWidget: (
                context,
                url,
                dynamic error,
              ) =>
                  const Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: AppSpacing.eightHorizontal,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.productName,
                style: AppTypography.kBold14,
              ),
              Text(
                'For: ${widget.buyer.profileName}',
                style: AppTypography.kExtraLight12,
              ),
            ],
          ),
          Spacer(),
          if (showStatus)
            ChangeOrderStatusButton(
              orderIndex: widget.orderIndex,
              orderItemIndex: widget.orderItemIndex,
            ),
        ]),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price'),
                  Text('\$${widget.product.price.toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quantity'),
                  Text('x${orderItem.quantity}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Service Fee'),
                  Text(
                      '\$${(orderItem.serviceFeeInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery Cost'),
                  Text(
                      '\$${(orderItem.deliveryCostInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax Amount'),
                  Text('\$${orderItem.tax.toStringAsFixed(2)}'),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'),
                  Text('\$${orderItem.grossTotal.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        ),
        if (cancelable)
          CancelAndRefundButton(
            orderIndex: widget.orderIndex,
            orderItemIndex: widget.orderItemIndex,
          ),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Colors.white,
        ),
      ],
    );
  }
}
