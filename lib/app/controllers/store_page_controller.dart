import 'dart:developer';

import 'package:cartisan/app/api_classes/social_api.dart';
import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:get/get.dart';

class StorePageController extends GetxController {
  final String userId;
  final userApi = UserAPI();
  final socialApi = SocialAPI();
  bool get isLoading => _isLoading.value;
  bool get isFollowing => _isFollowing.value;
  int get postCount => _postCount.value;
  bool get isBlocked => _isBlocked.value;
  UserModel? get storeOwner => _storeOwner.value;
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;
  RxInt _postCount = 0.obs;
  StorePageController({required this.userId});
  RxBool _isLoading = true.obs;
  Rx<UserModel?> _storeOwner = Rx<UserModel?>(null);
  RxBool _isFollowing = false.obs;
  RxBool _isBlocked = false.obs;
  @override
  onInit() async {
    initUser();
    super.onInit();
  }

  void initUser() async {
    _isLoading.value = true;
    _storeOwner.value = await userApi.getUser(userId);
    _isFollowing.value = await socialApi.isFollowing(
      userId: _currentUid,
      followId: userId,
    );
    _isBlocked.value = await socialApi.isBlocked(
      blockerId: Get.find<AuthService>().currentUser!.uid,
      blockedId: userId,
    );
    _postCount.value = await userApi.getUserPostCount(userId);
    _isLoading.value = false;
  }

  void unblockUser() async {
    Get.dialog<void>(LoadingDialog());
    final result = await socialApi.unblockUser(
      blockerId: _currentUid,
      blockedId: userId,
    );

    if (result) {
      _isBlocked.value = false;
    } else {
      showErrorDialog('Error unblocking user');
    }
    Get.back<void>();
  }

  void followUser() async {
    bool result;
    if (isFollowing) {
      result = await socialApi.unfollowUser(
        userId: _currentUid,
        followId: userId,
      );
    } else {
      result = await socialApi.followUser(
        userId: _currentUid,
        followId: userId,
      );
    }

    if (result) {
      if (isFollowing) {
        _storeOwner.value!.followerCount--;
      } else {
        _storeOwner.value!.followerCount++;
      }
      _isFollowing.value = !isFollowing;
    } else {
      await showErrorDialog('Error following user');
    }
  }
}
