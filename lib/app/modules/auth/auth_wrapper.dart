import 'package:cartisan/app/controllers/auth_controller.dart';
import 'package:cartisan/app/modules/auth/login_page.dart';
import 'package:cartisan/app/modules/home/home_view.dart';
import 'package:cartisan/app/modules/landingPage/landing_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends GetWidget<AuthController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      builder: (controller) {
        if (controller.user == null) return const LoginPage();
        return const LandingPage();
      },
    );
  }
}
