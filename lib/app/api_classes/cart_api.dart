import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/cart_item_model.dart';
import 'package:cartisan/app/models/post_model.dart';

String GET_POSTS_FROM_CART = '$BASE_URL/user/getPostsFromCart';
String ADD_TO_CART = '$BASE_URL/user/addToCart';
String GET_CART = '$BASE_URL/user/getCart';
String SET_CART_ITEM_COUNT = '$BASE_URL/user/setCartItemCount';
String DELETE_CART_ITEM = '$BASE_URL/user/deleteFromCart';
String CLEAR_CART = '$BASE_URL/cart/clearCart';

class CartAPI {
  APIService apiService = APIService();

  Future<List<PostModel>> getPostsFromCart(String userId) async {
    try {
      final result = await apiService.get<Map>(
        '$GET_POSTS_FROM_CART/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = result.data!['result'] as List;
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
      final result = await apiService.get<Map>(
        '$GET_CART/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = result.data!['data'] as List;
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
    required int quantity,
  }) async {
    try {
      final result = await apiService.put<Map>(
        '$ADD_TO_CART/$userId/$postId',
        {
          'selectedVariant': selectedVariant,
          'quantity': quantity == 0 ? 1 : quantity,
        },
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
      final result = await apiService.put<Map>(
        '$SET_CART_ITEM_COUNT/$userId/$cartItemId',
        jsonEncode({'amount': amount}),
      );
      log(result.toString());
      if (result.statusCode != 200) {
        throw Exception('Error updating cart count');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteCartItem({
    required String cartItemId,
    required String userId,
  }) async {
    try {
      final result = await apiService.delete<Map>(
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
      final result = await apiService.delete<Map>(
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
