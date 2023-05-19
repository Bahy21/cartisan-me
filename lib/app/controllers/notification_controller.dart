import 'dart:developer';
import 'package:cartisan/app/api_classes/notifications_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notificationApi = NotificationsAPI();
  List<NotificationModel> get notifications => _notifications.value;
  bool get isLoading => _isLoading.value;

  Rx<List<NotificationModel>> _notifications =
      Rx<List<NotificationModel>>(<NotificationModel>[]);
  RxBool _isLoading = true.obs;

  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> clearNotifications() async {
    _isLoading.value = true;
    final result = await notificationApi.clearNotifications(_currentUid);
    if (result) {
      _notifications
        ..value = []
        ..refresh();
    } else {
      showErrorDialog('Error clearing notifications');
    }
    _isLoading.value = false;
  }
}
