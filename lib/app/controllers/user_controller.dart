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
  set updateUserInController(UserModel user) => _userModel.value = user;
  @override
  void onInit() {
    _userModel.bindStream(UserRepo().currentUserStream());
    super.onInit();
  }
}
