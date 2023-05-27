import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
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
  final OrderModel order;
  final OrderItemModel orderItem;
  final PostModel product;
  final UserModel buyer;
  final bool sellerMode;
  final bool isCheckout;
  final int itemIndex;
  const OrderItemCard({
    required this.orderItem,
    required this.order,
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
  bool get cancelable =>
      widget.orderItem.status == OrderItemStatus.awaitingFulfillment &&
      !widget.isCheckout;

  bool get isEditable => [
        OrderItemStatus.awaitingFulfillment,
        OrderItemStatus.awaitingShipment,
        OrderItemStatus.shipped,
        OrderItemStatus.awaitingPickup,
      ].contains(widget.orderItem.status);
  bool get showStatus => ![
        OrderItemStatus.pending,
        OrderItemStatus.awaitingPayment,
      ].contains(widget.orderItem.status);
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
              order: widget.order,
              orderItem: widget.orderItem,
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
                  Text('x${widget.orderItem.quantity}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Service Fee'),
                  Text(
                      '\$${(widget.orderItem.serviceFeeInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery Cost'),
                  Text(
                      '\$${(widget.orderItem.deliveryCostInCents / 100).toPrecision(2).toStringAsFixed(2)}'),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax Amount'),
                  Text('\$${widget.orderItem.tax.toStringAsFixed(2)}'),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'),
                  Text('\$${widget.orderItem.grossTotal.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        ),
        if (cancelable)
          CancelAndRefundButton(
            order: widget.order,
            orderItem: widget.orderItem,
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
