import 'dart:developer';
import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:get/get.dart';

class CartService {
  final cartApi = CartAPI();
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  Future<bool> addToCart(PostModel post) async {
    try {
      return cartApi.addToCart(
        postId: post.postId,
        userId: _currentUid,
        selectedVariant: post.selectedVariant,
        quantity: post.quantity,
      );
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
