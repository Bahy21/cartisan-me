import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPageController extends GetxController {

  final as = Get.find<AuthService>();
  final dio = Dio();
  final apiCalls = ApiCalls();


  RxList<bool> _statuses = [true, false, false, false].obs;
  String get _currentUid => as.currentUser!.uid;
  Rx<List<CartItemModel>> _cart = Rx<List<CartItemModel>>(<CartItemModel>[]);
  List<CartModel> get cart => _cart.value;

  PageController initialScreenController = PageController();

  RxInt initialPageControllerIndex = 0.obs;
  int get initialPageIndex => initialPageControllerIndex.value;
  List<bool> get statusesValue => _statuses.value;

  set initialPageIndex(int index) {
    initialPageControllerIndex.value = index;
  }

  void updateStatus({required int index, required bool status}) {
    statuses[index] = status;
  }
  
  
  Future<void> getCart(){
    final result = dio.get(apiCalls.getApiCalls.getCart(_currentUid));
    if(result.isEmpty){
      log('cart is empty');
      return;
    }
    for(final cart in result){
      _cart.value.add(CartItemModel.fromMap(cart as Map<String, dynamic>));
    }
  }

  Future<void> clearCart(){
    dio.delete(apiCalls.deleteApiCalls.clearCart(_currentUid));
    _cart.value = [];
  }

  



  void reset() {
    initialPageControllerIndex.value = 0;
    statuses
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
