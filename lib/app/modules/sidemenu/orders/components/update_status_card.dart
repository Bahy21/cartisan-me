import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class UpdateStatusCard extends StatelessWidget {
  static const updatableStatus = [
    OrderItemStatus.awaitingFulfillment,
    OrderItemStatus.awaitingShipment,
    OrderItemStatus.shipped,
    OrderItemStatus.awaitingPickup,
    OrderItemStatus.completed,
  ];
  final OrderItemModel orderItem;
  final String orderId;

  const UpdateStatusCard({
    required this.orderItem,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: List.generate(
              updatableStatus.length,
              (index) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    Get.find<SalesHistoryController>().updateOrderItemStatus(
                      orderId: orderId,
                      orderItemId: orderItem.orderItemID,
                      status: updatableStatus[index],
                    );
                  },
                  child: Container(
                    color: orderItem.status == updatableStatus[index]
                        ? Colors.pink
                        : Colors.transparent,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 20,
                      ),
                      child: Text(
                        updatableStatus[index]
                            .toString()
                            .replaceAll('OrderItemStatus.', ''),
                        style: TextStyle(
                          color: orderItem.status == updatableStatus[index]
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
