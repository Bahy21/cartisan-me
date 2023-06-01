import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/post_response.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseDetailController extends GetxController {
  final OrderModel orderToBeFetched;
  final postApi = PostAPI();
  bool get loading => _loading.value;
  OrderModel get order => _order.value!;
  Map<String, PostResponse> get posts => _postResponse.value;
  PurchaseDetailController({required this.orderToBeFetched});

  RxBool _loading = true.obs;
  Rx<OrderModel?> _order = Rx<OrderModel?>(null);
  Rx<Map<String, PostResponse>> _postResponse =
      Rx<Map<String, PostResponse>>({});

  @override
  void onInit() {
    super.onInit();
    _order.value = orderToBeFetched;
    fetchOrderItemPosts();
  }

  void loadingComplete() {
    _loading.value = false;
  }

  Future<void> fetchOrderItemPosts() async {
    for (var orderItem in order.orderItems) {
      final post = await postApi.getPost(orderItem.productId);
      if (post != null) {
        _postResponse.value.addAll({orderItem.orderItemID: post});
      }
    }
    loadingComplete();
  }

  Future<void> createReview({
    required String postId,
    required ReviewModel review,
  }) async {
    Get.dialog<Widget>(
      LoadingDialog(),
      barrierDismissible: false,
    );
    final result =
        await postApi.createReview(postId: postId, newReview: review);
    Get.back<void>();
    if (result) {
      Get.back<void>();
      Get.snackbar('Success', 'Review created successfully');
    } else {
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
