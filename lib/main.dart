import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:cartisan/app/bindings/initial_bindings.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/data/global_functions/global_functions.dart';
import 'package:cartisan/app/modules/auth/auth_wrapper.dart';
import 'package:cartisan/app/modules/auth/auth_wrapper_external_post.dart';
import 'package:cartisan/app/modules/auth/auth_wrapper_external_profile.dart';
import 'package:cartisan/app/modules/profile/components/post_full_screen_external.dart';
import 'package:cartisan/app/modules/profile/components/user_post_full_screen.dart';
import 'package:cartisan/app/modules/profile/other_store_view.dart';
import 'package:cartisan/app/services/translation_service.dart';
import 'package:cartisan/default_firebase_options.dart';
import 'package:cartisan/secrets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';

bool useFunctionsEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await GetStorage.init();
  await Firebase.initializeApp(
    name: 'Cartisan',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.merchantIdentifier = 'Cartisan Exchange';
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await GlobalFunctions.initServicesAndControllers();
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      log(appLink.toString());
      openAppLink(appLink);
    }
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      log(appLink.toString());
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    _navigatorKey.currentState?.pushNamed(uri.path);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(390, 844),
      builder: (context, child) {
        return OKToast(
          duration: 2.5.seconds,
          animationCurve: Curves.easeIn,
          animationDuration: 600.milliseconds,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: GetMaterialApp(
              title: 'Cartisan',
              debugShowCheckedModeBanner: false,
              initialBinding: InitialBindings(),
              defaultTransition: Transition.fadeIn,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.dark,
              locale: const Locale('en_US'),
              translations: TranslationService(),
              navigatorKey: _navigatorKey,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                Widget routeWidget = const AuthWrapper();
                final routeName = settings.name;
                if (routeName != null) {
                  if (routeName.startsWith('/post')) {
                    final postId = routeName.split('/').last;

                    routeWidget = AuthWrapperExternalPost(postId: postId);
                  } else if (routeName.startsWith('/store')) {
                    final userId = routeName.split('/').last;

                    routeWidget = AuthWrapperExternalProfile(userId: userId);
                  }
                }
                return GetPageRoute<Widget>(
                  page: () => routeWidget,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final globalFunctions = GlobalFunctions();

  await globalFunctions.showNotification(message);
}
