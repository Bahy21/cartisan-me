import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/modules/profile/buyer_own_profile_page.dart';
import 'package:cartisan/app/modules/profile/store_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSellerWrapper extends StatelessWidget {
  const UserSellerWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      init: UserController(),
      autoRemove: false,
      builder: (controller) {
        return controller.currentUser?.isSeller ?? false
            ? StoreView()
            : const BuyerOwnProfilePage();
      },
    );
  }
}
