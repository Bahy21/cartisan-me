import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final as = Get.find<AuthService>();
  final dio = Dio();
  final apiCalls = ApiCalls();

  bool get isCartEmpty => _isCartEmpty.value;
  List<CartItemModel> get cart => _cart.value;
  Rx<List<CartItemModel>> _cart = Rx<List<CartItemModel>>([]);
  String get _currentUid => as.currentUser!.uid;
  RxBool _isCartEmpty = false.obs;
  @override
  void onReady() {
    getCart();
    super.onInit();
  }

  Future<void> getCart() async {
    final result =
        await dio.get<Map>(apiCalls.getApiCalls.getCart(_currentUid));
    final cartItems = result.data!['data'] as List;
    if (cartItems.isEmpty) {
      log('cart is empty');
      return;
    }
    for (final cartItem in cartItems) {
      cart.add(CartItemModel.fromMap(cartItem as Map<String, dynamic>));
    }
    _isCartEmpty.value = false;
  }

  Future<void> clearCart() async {
    await dio.delete<Map>(apiCalls.deleteApiCalls.clearCart(_currentUid));
    _cart.value = [];
  }
}
