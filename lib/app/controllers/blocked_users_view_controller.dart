import 'dart:developer';

import 'package:cartisan/app/api_classes/social_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BlockedUsersViewController extends GetxController {
  final socialApi = SocialAPI();
  List<UserModel> get blockedUsers => _blockedUsers.value;
  bool get loading => _loading.value;
  Rx<List<UserModel>> _blockedUsers = Rx<List<UserModel>>([]);
  RxBool _loading = true.obs;
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;
  final PagingController<int, UserModel> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    fetchPage(0);
    pagingController.addPageRequestListener(fetchPage);
    super.onInit();
  }

  void loadingComplete() {
    _loading.value = false;
  }

  void loadingStart() {
    _loading.value = true;
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      log('fetchPage: $pageKey');
      final allItems = pagingController.value.itemList;
      final newItems = await socialApi.getBlockList(
        _currentUid,
        lastBlockedUser:
            allItems == null || allItems.isEmpty ? null : allItems.last.id,
      );

      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
      loadingComplete();
    } on Exception catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> unblockUser(String userId) async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    final result = await socialApi.unblockUser(
      blockerId: _currentUid,
      blockedId: userId,
    );
    Get.back<void>();
    if (result) {
      pagingController.value.itemList?.removeWhere((user) => user.id == userId);
      Get.snackbar(
        'Success',
        'Unblocked successfully.',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
