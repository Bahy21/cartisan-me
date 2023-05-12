import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/cart_Item_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPageController extends GetxController {
  final as = Get.find<AuthService>();
  final dio = Dio();
  final apiCalls = ApiCalls();
  PageController initialScreenController = PageController();

  String get _currentUid => as.currentUser!.uid;

  List<bool> get statusesValue => _statuses.value;

  set initialPageIndex(int index) {
    initialPageControllerIndex.value = index;
  }

  int get initialPageIndex => initialPageControllerIndex.value;

  RxList<bool> _statuses = [true, false, false, false].obs;
  Rx<List<CartItemModel>> _cart = Rx<List<CartItemModel>>(<CartItemModel>[]);
  RxInt initialPageControllerIndex = 0.obs;

  void updateStatus({required int index, required bool status}) {
    _statuses[index] = status;
  }

  Future<void> getCart() async {
    final result =
        await dio.get<Map>(apiCalls.getApiCalls.getCart(_currentUid));
    final cartItems = result.data!['data'] as List;
    if (cartItems.isEmpty) {
      log('cart is empty');
      return;
    }
    for (final cart in cartItems) {
      _cart.value.add(CartItemModel.fromMap(cart as Map<String, dynamic>));
    }
  }

  Future<void> clearCart() async {
    await dio.delete<Map>(apiCalls.deleteApiCalls.clearCart(_currentUid));
    _cart.value = [];
  }

  void reset() {
    initialPageControllerIndex.value = 0;
    _statuses
      ..clear()
      ..addAll([true, false, false, false]);
  }

  Future<void> animateInitialPageToPrevious() async {
    initialPageControllerIndex.value = initialPageIndex - 1;
    await initialScreenController.previousPage(
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
  }

  Future<void> animateInitialPageToNext() async {
    initialPageControllerIndex.value = initialPageIndex + 1;

    await initialScreenController.nextPage(
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
  }

  void jumpToIndex(int index) {
    initialScreenController.animateToPage(
      index,
      duration: 500.milliseconds,
      curve: Curves.easeIn,
    );
    initialPageIndex = index;
  }
}
