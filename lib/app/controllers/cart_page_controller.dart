import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPageController extends GetxController {
  final RxList<bool> _statuses = [true, false, false, false].obs;

  PageController initialScreenController = PageController();

  RxInt initialPageControllerIndex = 0.obs;
  int get initialPageIndex => initialPageControllerIndex.value;
  // ignore: invalid_use_of_protected_member
  List<bool> get statusesValue => _statuses.value;

  set initialPageIndex(int index) {
    initialPageControllerIndex.value = index;
  }

  void updateStatus({required int index, required bool status}) {
    _statuses[index] = status;
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
