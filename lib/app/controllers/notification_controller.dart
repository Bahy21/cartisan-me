import 'dart:developer';
import 'package:cartisan/app/api_classes/notifications_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notificationApi = NotificationsAPI();
  List<NotificationModel> get notifications => _notifications.value;
  bool get isLoading => _isLoading.value;
  int get totalNotificationsLoaded => _totalNotificationsLoaded.value;
  bool get isNotifcationsLoading => _isNotifcationsLoading.value;

  Rx<List<NotificationModel>> _notifications =
      Rx<List<NotificationModel>>(<NotificationModel>[]);
  RxBool _isLoading = true.obs;
  RxInt _totalNotificationsLoaded = 0.obs;
  RxBool _isNotifcationsLoading = false.obs;

  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    _isNotifcationsLoading.value = true;
    if (isRefresh) {
      _isLoading.value = true;
    }
    String? lastId;
    if (_notifications.value.isNotEmpty && !isRefresh) {
      lastId = _notifications.value.last.notificationId;
    }
    final results = await notificationApi.getNotifications(
      _currentUid,
      lastId,
    );
    if (results.isEmpty) {
      _isNotifcationsLoading.value = false;
      _isLoading.value = false;
      return;
    }

    _notifications.value = [...notifications, ...results];
    _isNotifcationsLoading.value = false;
    _isLoading.value = false;
  }
}
