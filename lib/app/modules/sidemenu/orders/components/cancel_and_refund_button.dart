import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/cancel_order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelAndRefundButton extends StatefulWidget {
  final OrderModel order;
  final OrderItemModel orderItem;
  const CancelAndRefundButton({
    required this.order,
    required this.orderItem,
    Key? key,
  }) : super(key: key);

  @override
  State<CancelAndRefundButton> createState() => _CancelAndRefundButtonState();
}

class _CancelAndRefundButtonState extends State<CancelAndRefundButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            await cancelOrderItem(
              widget.order,
              widget.orderItem,
            );
          },
          child: Container(
            color: Colors.red[700],
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Text(
                "Cancel Item And Refund".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
