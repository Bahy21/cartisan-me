import 'dart:developer';
import 'package:cartisan/app/api_classes/user_api.dart';
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
}
