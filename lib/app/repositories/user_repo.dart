import 'dart:developer';

import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:get/get.dart';

class UserRepo {
  final userDb = UserDatabase();
  final userApi = UserAPI();
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  Stream<UserModel?> currentUserStream() {
    log('getting current user stream');
    return userDb.usersCollection
        .doc(_currentUid)
        .snapshots()
        .map((event) => event.data());
  }
}
