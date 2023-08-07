import 'dart:developer';

import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/notification_service.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/repositories/user_repo.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final dio = Dio();
  final db = Database();
  final ac = Get.find<AuthService>();
  UserModel? get currentUser => _userModel.value;
  int get userPostCount => _userPostCount.value;
  // ignore: prefer_final_fields
  int retries = 0;
  final RxInt _userPostCount = 0.obs;
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  set updateUserInController(UserModel user) => _userModel.value = user;
  Worker? worker;
  @override
  void onInit() {
    _userModel.bindStream(UserRepo().currentUserStream());
    super.onInit();
  }

  @override
  void onReady() {
    ever<UserModel?>(_userModel, (callback) {
      if (callback == null) return;
      log('user model is not null');
      // getUserPostCount();
    });

    // log('controller ready');
    // log(currentUser.toString());
    // if (currentUser != null) {
    //   NotificationService().init();
    //   getUserPostCount();
    // } else {
    //   log('user is null');
    //   worker = registerUserNotifications();
    // }
    super.onReady();
  }

  /// Returns the latest stripe seller ID from db.
  Stream<String> stripeAccountStream() {
    return UserRepo().currentUserStream().map((snapshot) {
      return snapshot!.sellerID;
    });
  }

  Worker registerUserNotifications() {
    log('registering user notifications');
    return once(
      _userModel,
      (callback) async {
        log('user is no longer null, calling notifications');
        await NotificationService().init();
        await getUserPostCount();
      },
      condition: _userModel.value == null,
      onError: () {
        retries++;
        log('Notifications: retrying $retries');
        if (retries < 5) {
          registerUserNotifications();
        }
      },
      onDone: () => log('Notifications: initialized'),
      cancelOnError: true,
    );
  }

  Future<void> getUserPostCount() async {
    _userPostCount.value =
        await UserAPI().getUserPostCount(ac.currentUser!.uid);
  }
}
