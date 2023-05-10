import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:get/get.dart';

class GlobalFunctions {
  static Future<void> initServicesAndControllers() async {
    await Get.putAsync<AuthService>(() async => AuthService());
  }
}
