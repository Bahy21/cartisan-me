import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/notification_model.dart';

const String GET_NOTIFICATIONS = '$BASE_URL/notifications/getNotifications';
const String CLEAR_NOTIFICATIONS = '$BASE_URL/notifications/clearNotifications';

class NotificationsAPI {
  final apiService = APIService();
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    String? lastSentNotificationId,
    int? limit,
  }) async {
    final int count = limit ?? 10;
    final results = await apiService.getPaginate<Map>(
        '$GET_NOTIFICATIONS/$userId/$count', <String, dynamic>{
      'lastNotificationId': lastSentNotificationId,
    });
    log(results.toString());
    final notificationsGotten = results.data!['data'] as List;
    final newNotifications = <NotificationModel>[];
    for (final notification in notificationsGotten) {
      newNotifications
          .add(NotificationModel.fromMap(notification as Map<String, dynamic>));
    }
    return newNotifications;
  }

  Future<bool> clearNotifications(String userId) async {
    try {
      final results =
          await apiService.delete<Map>('$CLEAR_NOTIFICATIONS/$userId');
      if (results.statusCode != 200) {
        throw Exception('Error clearing notifications');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
