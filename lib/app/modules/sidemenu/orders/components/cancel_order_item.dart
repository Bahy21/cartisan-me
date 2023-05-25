import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/api_classes/payment_api.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> cancelOrderItem(OrderModel order, OrderItemModel orderItem) async {
  await confirmationDialog(
    "Are you sure you want to cancel this Item?",
    onConfirm: () => cancel(order, orderItem),
    onCancel: () {
      Get.back<void>();
    },
  );
}

Future<void> cancel(
  OrderModel order,
  OrderItemModel orderItem,
) async {
  final result = await PaymentAPI().cancelAndRefund(
    orderId: order.orderId,
    orderItemId: orderItem.orderItemID,
  );
  if (result) {
    Get.snackbar(
      'Success',
      'Item Cancelled',
      colorText: Colors.white,
      backgroundColor: Colors.black45,
      snackPosition: SnackPosition.TOP,
      duration: 2.5.seconds,
      mainButton: TextButton(
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () async {
          await Get.closeCurrentSnackbar();
        },
      ),
    );
  } else {
    await showErrorDialog('Error processing refund\nPlease try again later');
  }
}

Future<void> confirmationDialog(
  String confirmationMessage, {
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) async {
  await Get.defaultDialog<Widget>(
    backgroundColor: Colors.white,
    content: Text(
      confirmationMessage,
      textAlign: TextAlign.center,
    ),
    onConfirm: onConfirm,
    onCancel: onCancel,
  );
  return;
}
