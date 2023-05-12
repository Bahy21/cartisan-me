import 'dart:developer';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/notification_model.dart';
import 'package:cartisan/app/services/api_calls.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final dio = Dio();
  final apiCalls = ApiCalls();
  final as = Get.find<AuthService>();

  List<NotificationModel> get notifications => _notifications.value;
  bool get isLoading => _isLoading.value;
  int get totalNotificationsLoaded => _totalNotificationsLoaded.value;
  bool get isNotifcationsLoading => _isNotifcationsLoading.value;

  Rx<List<NotificationModel>> _notifications =
      Rx<List<NotificationModel>>(<NotificationModel>[]);
  RxBool _isLoading = true.obs;
  RxInt _totalNotificationsLoaded = 0.obs;
  RxBool _isNotifcationsLoading = false.obs;

  String get _currentUid => as.currentUser!.uid;

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    _isNotifcationsLoading.value = true;
    if (isRefresh) {
      _isLoading.value = true;
    }
    List<NotificationModel> newNotificatoins = <NotificationModel>[];
    log('fetching posts on init');
    String? lastId;
    if (_notifications.value.isNotEmpty && !isRefresh) {
      lastId = _notifications.value.last.notificationId;
    }
    final results = await dio.get<Map>(
      apiCalls.getApiCalls.getNotifications(_currentUid),
      data: {'lastNotificationId': lastId},
    );
    final notificationsGotten = results.data!['data'] as List;
    if (notificationsGotten.isEmpty) {
      _isNotifcationsLoading.value = false;
      _isLoading.value = false;
      return;
    }
    List<NotificationModel> newNotifications = [];
    _totalNotificationsLoaded.value = isRefresh
        ? notificationsGotten.length
        : _totalNotificationsLoaded.value + notificationsGotten.length;
    for (final notification in notificationsGotten) {
      newNotifications
          .add(NotificationModel.fromMap(notification as Map<String, dynamic>));
    }
    _notifications.value = [...notifications, ...newNotifications];
    _isNotifcationsLoading.value = false;
    _isLoading.value = false;
  }
}
