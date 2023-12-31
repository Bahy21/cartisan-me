import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class UpdateStatusCard extends StatelessWidget {
  static const updatableStatus = [
    OrderItemStatus.awaitingFulfillment,
    OrderItemStatus.awaitingShipment,
    OrderItemStatus.shipped,
    OrderItemStatus.awaitingPickup,
    OrderItemStatus.completed,
  ];
  final int orderItemIndex;
  final int orderIndex;

  const UpdateStatusCard({
    required this.orderItemIndex,
    required this.orderIndex,
    Key? key,
  }) : super(key: key);
  OrderItemModel get orderItem => Get.find<SalesHistoryController>()
      .sales[orderIndex]
      .orderItems[orderItemIndex];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            updatableStatus.length,
            (index) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () async {
                  await Get.find<SalesHistoryController>()
                      .updateOrderItemStatus(
                    orderIndex: orderIndex,
                    orderItemIndex: orderItemIndex,
                    status: updatableStatus[index],
                  );
                  Get.back<void>();
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
                      updatableStatus[index].name,
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
        ],
      ),
    );
  }
}

//