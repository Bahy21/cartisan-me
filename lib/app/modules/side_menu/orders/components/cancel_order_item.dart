import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/api_classes/payment_api.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> cancelOrderItem(int orderIndex, int orderItemIndex) async {
  await confirmationDialog(
    'Are you sure you want to cancel this Item?',
    onConfirm: () => cancel(
      orderIndex,
      orderItemIndex,
    ),
    onCancel: () {},
  );
}

Future<void> cancel(
  int orderIndex,
  int orderItemIndex,
) async {
  Get
    ..back<void>()
    ..dialog<Widget>(const LoadingDialog());
  final order = Get.find<SalesHistoryController>().sales[orderIndex];
  final orderItem = order.orderItems[orderItemIndex];
  final result = await PaymentAPI().cancelAndRefund(
    orderId: order.orderId,
    orderItemId: orderItem.orderItemID,
  );
  if (result) {
    Get
      ..back<void>()
      ..snackbar(
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
    order.orderItems[orderItemIndex].status = OrderItemStatus.cancelled;
  } else {
    Get.back<void>();
    await showErrorDialog('Error processing refund\nPlease try again later');
  }
}

Future<void> confirmationDialog(
  String confirmationMessage, {
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) async {
  await Get.defaultDialog<Widget>(
    backgroundColor: AppColors.kBackground,
    content: Text(
      confirmationMessage,
      textAlign: TextAlign.center,
    ),
    onConfirm: onConfirm,
    onCancel: onCancel,
    confirmTextColor: Colors.black,
    cancelTextColor: AppColors.kPrimary,
    buttonColor: AppColors.kPrimary,
  );
}
