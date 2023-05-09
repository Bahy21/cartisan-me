import 'package:cartisan/api_root.dart';
import 'package:cartisan/app/controllers/auth_controller.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final ac = Get.find<AuthController>();
  final dio = Dio();
  UserModel? get currentUser => _userModel.value;

  // ignore: prefer_final_fields
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);

  Future<UserModel?> fetchUser(String userId) async {
    try {
      final apiCall = '$apiRoot/api/user/getUser/$userId';
      final result = await dio.get<Map>(apiCall);
      if (result.statusCode != 200) {
        throw Exception('Error fetching posts');
      }
      final userMap = result.data!['data'] as Map<String, dynamic>;
      return UserModel.fromMap(userMap);
    } on Exception catch (e) {
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
