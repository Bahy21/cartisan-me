import 'package:cartisan/app/controllers/auth_controller.dart';
import 'package:cartisan/app/controllers/timeline_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<AuthController>(AuthController.new, fenix: true)
      ..lazyPut<UserController>(UserController.new, fenix: true)
      ..lazyPut<TimelineController>(TimelineController.new, fenix: true);
  }
}
