import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);

  User? get currentUser => firebaseUser.value;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  // ignore: prefer_final_fields
  RxBool _isLoading = true.obs;
  RxString userToken = ''.obs;
  Timer? timer;

  void initAuthToken() async {
    userToken.value = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    initAuthToken();
    handleEmailVerification();
    ever(firebaseUser, (callback) async {
      userToken.value =
          await FirebaseAuth.instance.currentUser!.getIdToken(true);
      log("Set the token to $userToken");
    });
    timer = Timer.periodic(45.minutes, (callback) async {
      userToken.value =
          await FirebaseAuth.instance.currentUser!.getIdToken(true);
      log("Set the token to $userToken");
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void handleEmailVerification() {
    0.milliseconds.delay().then((dynamic _) => _isLoading.value = false);
  }

  Future<void> handlePasswordReset(String email) async {
    log('Sending password reset email to $email');
    await _auth.sendPasswordResetEmail(email: email);
  }
}
