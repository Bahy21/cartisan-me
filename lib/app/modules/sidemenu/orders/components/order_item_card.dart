import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/cancel_and_refund_button.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/change_order_status_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  bool get isEditable =>
      widget.sellerMode &&
      [
        OrderItemStatus.awaitingFulfillment,
        OrderItemStatus.awaitingShipment,
        OrderItemStatus.shipped,
        OrderItemStatus.awaitingPickup,
      ].contains(widget.orderItem.status);
  bool get showStatus => ![
        OrderItemStatus.pending,
        OrderItemStatus.awaitingPayment,
      ].contains(widget.orderItem.status);
//setstate call horhi? idk
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: Colors.white,
        ),
        ListTile(
          leading: CachedNetworkImage(
            imageUrl: widget.product.images.first,
            width: 50,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, dynamic error) => Icon(Icons.error),
          ),
          title: Text(widget.product.productName),
          subtitle: Text('For: ${widget.buyer.profileName}'),
          trailing: showStatus
              ? Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      widget.orderItem.status.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : null,
        ),
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
        if (isEditable)
          ChangeOrderStatusButton(
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
