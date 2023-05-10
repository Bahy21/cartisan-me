import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/modules/auth/login_page.dart';
import 'package:cartisan/app/modules/home/home_view.dart';
import 'package:cartisan/app/modules/landingPage/landing_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});
  AuthService authService = Get.find<AuthService>();

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
      if (authService.user == null) {
        return const LoginPage();
      }
      return GetBuilder(
        init: UserController(),
        builder: (controller) {
          return const LandingPage();
        },
      );
    });
  }
}
