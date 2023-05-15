import 'dart:developer';
import 'package:cartisan/app/api_controllers.dart/user_api.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserRepo {
  final userDb = UserDatabase();
  final userApi = UserAPI();
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  Stream<UserModel?> currentUserStream() {
    return userDb.usersCollection
        .doc(_currentUid)
        .snapshots()
        .map((event) => event.data());
  }

  Future<UserModel?> fetchUser(String userId) async {
    return userApi.getUser(userId);
  }

  Future<bool> addUserAddress(AddressModel address) async {
    try {
      final result = await dio.put<Map>(
        _apiCalls.putApiCalls.addAddress(_currentUid),
        data: address.toJson(),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> updateDeliveryInfo(
      {required bool activeShipping,
      required bool pickup,
      required bool isDeliveryAvailable}) async {
    try {
      final result = await dio.put<Map>(
          _apiCalls.putApiCalls.updateDeliveryInfo(_currentUid),
          data: {
            'activeShipping': activeShipping,
            'pickup': pickup,
            'isDeliveryAvailable': isDeliveryAvailable
          });
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<void> followUser({
    required String userId,
    required String followId,
  }) async {
    try {
      final result = await dio.put<Map>(
        _apiCalls.putApiCalls.followUser(userId: userId, followId: followId),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> unfollowUser({
    required String userId,
    required String followId,
  }) async {
    try {
      final result = await dio.delete<Map>(_apiCalls.deleteApiCalls
          .unfollowUser(userId: userId, followId: followId));
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<bool> isFollowing({
    required String userId,
    required String followId,
  }) async {
    try {
      final result = await dio.get<Map>(_apiCalls.getApiCalls
          .isFollowing(userId: userId, followId: followId));
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> updateUserDetails(
      {required String userId, required UserModel newUser}) async {
    try {
      final result = await dio.put<Map>(
        _apiCalls.putApiCalls.updateUserDetails(userId),
        data: newUser.toJson(),
      );
      if (result.statusCode != 200) {
        throw Exception('Something went wrong');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  Future<bool> addToCart(PostModel post) async {
    try {
      return userAPI.addToCart(
        postId: post.postId,
        userId: _currentUid,
        selectedVariant: post.selectedVariant,
      );
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
