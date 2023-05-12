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
  RxBool _isCartEmpty = true.obs;
  @override
  void onInit() {
    getCart();
    super.onInit();
  }

  Future<void> getCart() async {
    _cart.value = [];
    log('get cart called');
    final result =
        await dio.get<Map>(apiCalls.getApiCalls.getCart(_currentUid));
    final cartItems = result.data!['data'] as List;
    if (cartItems.isEmpty) {
      _isCartEmpty.value = true;
      log('cart is empty');
      return;
    }
    if (cartItems.isEmpty) {
      return;
    }
    for (final cartItem in cartItems) {
      cart.add(CartItemModel.fromMap(cartItem as Map<String, dynamic>));
    }
    _isCartEmpty.value = false;
  }

  Future<void> deleteCartItem(String cartItemId) async {
    final confirmation =
        await dio.delete<Map>(apiCalls.deleteApiCalls.deleteCartItem(
      userId: _currentUid,
      itemId: cartItemId,
    ));
    if (confirmation.statusCode != 200) {
      log(confirmation.toString());
      Get.snackbar('Error', 'Something went wrong');
      return;
    }
    for (var cartItem in cart) {
      if (cartItem.cartItemId == cartItemId) {
        cart.remove(cartItem);
        break;
      }
    }
    if (cart.isEmpty) {
      _isCartEmpty.value = true;
    }
  }

  Future<void> clearCart() async {
    await dio.delete<Map>(apiCalls.deleteApiCalls.clearCart(_currentUid));
    _cart.value = [];
  }
}
