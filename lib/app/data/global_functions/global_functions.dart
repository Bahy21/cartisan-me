import 'dart:developer';

import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class GlobalFunctions {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> initServicesAndControllers() async {
    await Get.putAsync<AuthService>(() async => AuthService());
  }

  // Method used to show notifications.
  Future<void> showNotification(
    RemoteMessage message,
  ) async {
    log('showing notification');
    await flutterLocalNotificationsPlugin.show(
      1,
      message.notification?.title ?? 'Cartisan',
      message.notification?.body ?? 'New Notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'basic_channel',
          'Basic notifications',
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> initializeNotification() async {
    try {
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS =
          DarwinInitializationSettings();
      final initializationSettings = const InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
