// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/modules/profile/buyer_own_profile_page.dart';
import 'package:cartisan/app/modules/profile/components/user_seller_wrapper.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/modules/auth/login_page.dart';
import 'package:cartisan/app/modules/landingPage/landing_page.dart';
import 'package:cartisan/app/modules/profile/components/post_full_screen_external.dart';

class AuthWrapperExternalProfile extends StatelessWidget {
  final String userId;
  const AuthWrapperExternalProfile({
    required this.userId,
    Key? key,
  }) : super(key: key);
  AuthService get authService => Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authService.isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      }
      if (authService.currentUser == null) {
        return const LoginPage();
      }
      return GetBuilder(
        init: UserController(),
        builder: (controller) {
          return Get.find<AuthService>().currentUser!.uid != userId
              ? OtherStoreView(userId: userId)
              : const UserSellerWrapper();
        },
      );
    });
  }
}
