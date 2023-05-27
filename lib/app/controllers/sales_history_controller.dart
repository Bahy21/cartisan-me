import 'dart:developer';

import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SalesHistoryController extends GetxController {
  final orderApi = OrderAPI();
  final box = GetStorage();
  final userId = Get.find<AuthService>().currentUser!.uid;
  List<OrderModel> get sales => _sales.value;
  bool get noSalesFound => _noSalesFound.value;
  Rx<List<OrderModel>> _sales = Rx<List<OrderModel>>([]);
  RxBool _noSalesFound = false.obs;
  @override
  void onInit() {
    loadSalesFromLocal();
    super.onInit();
  }

  void loadSalesFromLocal() {
    final result = box.read<List>('sales');
    if (result != null) {
      final orders = <OrderModel>[];
      for (final order in result) {
        orders.add(OrderModel.fromMap(order as Map<String, dynamic>));
      }
      _sales.value = orders;
    } else {
      loadSalesFromApi();
    }
  }

  Future<void> loadSalesFromApi() async {
    final result = await orderApi.getSoldOrders(userId);
    if (result.isNotEmpty) {
      _sales.value = result;
      await box.write('purchases', result.map((e) => e.toMap()).toList());
    }
    if (sales.isEmpty) {
      _noSalesFound.value = true;
    }
  }

  Future<void> updateOrderItemStatus({
    required String orderId,
    required String orderItemId,
    required OrderItemStatus status,
  }) async {
    Get.dialog<Widget>(const LoadingDialog());
    final result = await orderApi.updateOrderItemStatus(
      orderId: orderId,
      orderItemId: orderItemId,
      newStatus: status,
    );
    if (result) {
      _sales.value.asMap().forEach(
        (key, value) {
          value.orderItems.asMap().forEach(
            (index, value) async {
              if (value.orderItemID == orderItemId) {
                _sales.value[key].orderItems[index].status = status;
                await box.write(
                  'purchases',
                  _sales.value.map((e) => e.toMap()).toList(),
                );
              }
            },
          );
        },
      );
      Get.back<void>();
    } else {
      await showErrorDialog('Error\nFailed to update status');
    }
  }
}
