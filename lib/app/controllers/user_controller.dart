import 'dart:developer';

import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/notification_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/repositories/user_repo.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final dio = Dio();
  final db = Database();
  AuthService ac = Get.find<AuthService>();
  UserModel? get currentUser => _userModel.value;
  int get userPostCount => _userPostCount.value;
  // ignore: prefer_final_fields
  RxInt _userPostCount = 0.obs;
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  set updateUserInController(UserModel user) => _userModel.value = user;
  @override
  void onInit() {
    _userModel.bindStream(UserRepo().currentUserStream());
    super.onInit();
  }

  @override
  void onReady() {
    log('controller ready');
    log(currentUser.toString());
    if (currentUser != null) {
      NotificationService().init();
      getUserPostCount();
    }
    super.onReady();
  }

  void getUserPostCount() async {
    _userPostCount.value =
        await UserAPI().getUserPostCount(ac.currentUser!.uid);
  }
}
