import 'dart:developer';

import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PurchaseHistoryController extends GetxController {
  final orderApi = OrderAPI();
  final box = GetStorage();
  final userId = Get.find<AuthService>().currentUser!.uid;
  List<OrderModel> get purchases => _purchases.value;
  bool get noPurchasesFound => _noPurchasesFound.value;
  Rx<List<OrderModel>> _purchases = Rx<List<OrderModel>>([]);
  RxBool _noPurchasesFound = false.obs;
  @override
  void onInit() {
    loadPurchasesFromLocal();
    super.onInit();
  }

  void loadPurchasesFromLocal() {
    final result = box.read<List>('purchases');
    if (result != null) {
      final orders = <OrderModel>[];
      for (final order in result) {
        orders.add(OrderModel.fromMap(order as Map<String, dynamic>));
      }
      _purchases.value = orders;
    } else {
      loadPurchasesFromApi();
    }
  }

  Future<void> loadPurchasesFromApi() async {
    final result = await orderApi.getPurchasedOrders(userId);
    log(result.toString());
    if (result.isNotEmpty) {
      _purchases.value = result;
      await box.write('purchases', result.map((e) => e.toMap()).toList());
    }
    if (result.isEmpty) {
      await box.write('purchases', <OrderModel>[]);
      _noPurchasesFound.value = true;
    }
  }
}
