import 'dart:developer';
import 'package:cartisan/api_root.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/repositories/user_repo.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final dio = Dio();
  final db = Database();
  Map cache = <String, UserModel>{};
  AuthService ac = Get.find<AuthService>();
  UserModel? get currentUser => _userModel.value;
  // ignore: prefer_final_fields
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    _userModel.bindStream(UserRepo().currentUserStream());
    super.onInit();
  }

  Future<UserModel?> fetchUser(String userId) async {
    try {
      // Can we implement a cache of the last 10 users fetched? A map of userId to UserModel sorted by timestamp?
      if (cache.keys.contains(userId)) {
        return cache[userId] as UserModel;
      }
      final apiCall = '$apiRoot/api/user/getUser/$userId';
      final result = await dio.get<Map>(apiCall);
      if (result.statusCode != 200) {
        throw Exception('Error fetching posts');
      }
      final userMap = result.data!['data'] as Map<String, dynamic>;
      final user = UserModel.fromMap(userMap);
      cache[userId] = user;
      return user;
    } on Exception catch (e) {
      log(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }
}
