import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/sidemenu/orders/components/update_status_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeOrderStatusButton extends StatefulWidget {
  final OrderModel order;
  final OrderItemModel orderItem;
  const ChangeOrderStatusButton({
    Key? key,
    required this.order,
    required this.orderItem,
  }) : super(key: key);

  @override
  State<ChangeOrderStatusButton> createState() =>
      _ChangeOrderStatusButtonState();
}

class _ChangeOrderStatusButtonState extends State<ChangeOrderStatusButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () async {
            if (_isLoading) return;
            try {
              setState(() {
                _isLoading = true;
              });
              await Get.bottomSheet<Widget>(
                UpdateStatusCard(
                  orderItem: widget.orderItem,
                  orderId: widget.order.orderId,
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      "Change Order Status".toUpperCase(),
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
