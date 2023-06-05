// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/api_classes/report_api.dart';
import 'package:cartisan/app/api_classes/social_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/modules/cart/cart_view_pages.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/modules/widgets/dialogs/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final cartApi = CartAPI();
  final reportApi = ReportAPI();
  final postApi = PostAPI();
  final socialApi = SocialAPI();
  String get currentUserId => Get.find<AuthService>().currentUser!.uid;
  void buyNow(PostResponse postResponse) async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    final result = await CartAPI().addToCart(
      postId: postResponse.post.postId,
      userId: currentUserId,
      selectedVariant: postResponse.post.selectedVariant,
      quantity: postResponse.post.quantity,
    );
    if (result) {
      Get
        ..back<void>()
        ..to<Widget>(() => CartViewPages());
    } else {
      Get.back<void>();
      await showErrorDialog('Error creating order');
    }
  }

  void toToOtherProfile(String userId) {
    Get.to<Widget>(OtherStoreView(userId: userId));
  }

  Future<bool> archiveController(PostResponse postResponse) async {
    Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
    bool result = false;
    if (postResponse.post.archived) {
      result = await postApi.unarchivePost(postResponse.post.postId);
    } else {
      result = await postApi.archivePost(postResponse.post.postId);
    }
    Get.back<void>();
    return result;
  }

  Future<void> reportPost(PostResponse postResponse) async {
    Get.dialog<Widget>(
      const LoadingDialog(),
      barrierDismissible: false,
    );
    final result = await ReportAPI().reportPost(
      post: postResponse.post,
      reportedFor: '',
    );
    Get.back<void>();
    if (result) {
      showToast('Post Reported');
    } else {
      await showErrorDialog('Error reporting post');
    }
  }

  Future<void> addToCart({
    required String postId,
    required String selectedVariant,
    required int quantity,
  }) async {
    Get.dialog<Widget>(LoadingDialog());
    final result = await cartApi.addToCart(
      postId: postId,
      userId: currentUserId,
      selectedVariant: selectedVariant,
      quantity: quantity,
    );
    Get.back<void>();
    if (result) {
      showToast('Added to cart');
    } else {
      await showErrorDialog('Error adding to cart');
    }
  }
}
