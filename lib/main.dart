import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cartisan/app/bindings/initial_bindings.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/global_functions.dart';
import 'package:cartisan/app/modules/auth/auth_wrapper.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:cartisan/default_firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await GetStorage.init();
  await Firebase.initializeApp(
    name: "Cartisan",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }
  await GlobalFunctions.initServicesAndControllers();
  FlutterNativeSplash.remove();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Cartisan',
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBindings(),
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          defaultTransition: Transition.fadeIn,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          locale: const Locale('en_US'),
          translations: TranslationService(),
          home: AuthWrapper(),
        );
      },
    );
  }
}

Future<void> initializeNotifications() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.pink,
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: true,
  );
}
