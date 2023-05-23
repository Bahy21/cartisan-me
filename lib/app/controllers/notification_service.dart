import 'dart:developer';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/global_functions/global_functions.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService {
  final firestore = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;
  final db = Database();
  final userController = Get.find<UserController>();
  UserModel get currentUser => userController.currentUser!;
  final _globalFunctions = GlobalFunctions();
  bool initialized = false;
  Future<bool> initializeNotificationsPermissions() async {
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
      return true;
    } else {
      log('User declined or has not accepted permission');
      return false;
    }
  }

  Future<void> init() async {
    try {
      // * initialization
      await initializeNotificationsPermissions();
      await _globalFunctions.initializeNotification();
      final messagingToken = await getMessagingToken();

      log(messagingToken.toString());

      if (messagingToken != null) {
        final currentUserRef = db.userCollection.doc(currentUser.id);
        log('Handling notification Activity');
        await currentUserRef
            .update({'androidNotificationToken': messagingToken});
        messaging.onTokenRefresh.listen((token) async {
          await currentUserRef
              .update({'androidNotificationToken': messagingToken});
        });
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          log('hellow howww');
          _globalFunctions.showNotification(message);
        });
        FirebaseMessaging.onMessage.listen((message) async {
          log('hellow howww');
          await _globalFunctions.showNotification(
            message,
          );
        });

        log('Notifications initialized');
        initialized = true;
      }
    } catch (e) {
      log('Error initializing notifications');
      log(e.toString());
    }
  }

  Future<String?> getMessagingToken() async {
    log('generating messaging token');
    final messagingToken = await messaging.getToken();
    log('messagingToken: $messagingToken');
    return messagingToken;
  }
}
