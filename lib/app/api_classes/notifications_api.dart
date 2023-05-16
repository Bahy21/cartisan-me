import 'dart:convert';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/notification_model.dart';

const String GET_NOTIFICATIONS = '$BASE_URL/notifications/getNotifications';

class NotificationsAPI {
  final apiService = APIService();
  Future<List<NotificationModel>> getNotifications(
      String userId, String? lastSentNotificationId) async {
    final results = await apiService
        .getPaginate<Map>('$GET_NOTIFICATIONS/$userId', <String, dynamic>{
      'lastNotificationId': lastSentNotificationId,
    });
    final notificationsGotten = jsonDecode(results.data.toString()) as List;
    final newNotifications = <NotificationModel>[];
    for (final notification in notificationsGotten) {
      newNotifications
          .add(NotificationModel.fromMap(notification as Map<String, dynamic>));
    }
    return newNotifications;
  }
}
