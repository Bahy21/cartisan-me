import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:cartisan/app/models/post_model.dart';

const String GET_POSTS_FROM_CART = '$BASE_URL/user/getPostsFromCart';
const String ADD_TO_CART = '$BASE_URL/user/addToCart';
const String GET_CART = '$BASE_URL/user/getCart';
const String SET_CART_ITEM_COUNT = '$BASE_URL/user/setCartItemCount/';
const String DELETE_CART_ITEM = '$BASE_URL/user/deleteFromCart';
const String CLEAR_CART = '$BASE_URL/cart/clearCart';

class CartAPI {
  APIService apiService = APIService();

  Future<List<PostModel>> getPostsFromCart(String userId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_POSTS_FROM_CART/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final posts = <PostModel>[];
      for (final post in data) {
        posts.add(PostModel.fromMap(post as Map<String, dynamic>));
      }
      return posts;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<CartItemModel>> getCart(String userId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_CART/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final cart = <CartItemModel>[];
      for (final cartItem in data) {
        cart.add(CartItemModel.fromMap(cartItem as Map<String, dynamic>));
      }
      return cart;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> addToCart({
    required String postId,
    required String userId,
    required String selectedVariant,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$ADD_TO_CART/$userId/$postId',
        jsonEncode({'selectedVariant': selectedVariant}),
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating user delivery');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> setCartItemCount({
    required String userId,
    required String cartItemId,
    required int amount,
  }) async {
    try {
      final result = await apiService.put<String>(
        '$SET_CART_ITEM_COUNT/$userId/$cartItemId',
        jsonEncode({'amount', amount}),
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating cart count');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteCartItem(
      {required String cartItemId, required String userId}) async {
    try {
      final result = await apiService.delete<String>(
        '$DELETE_CART_ITEM/$userId/$cartItemId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error deleting cart item');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> clearCart(String userId) async {
    try {
      final result = await apiService.delete<String>(
        '$CLEAR_CART/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error clearing cart');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
