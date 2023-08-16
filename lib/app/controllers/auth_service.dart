import 'dart:async';
import 'dart:developer';

import 'package:cartisan/app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);
  Database db = Database();

  RxString userToken = ''.obs;
  // Timer? timer;
  User? get currentUser => firebaseUser.value;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  // ignore: prefer_final_fields
  RxBool _isLoading = true.obs;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    handleEmailVerification();
    ever(firebaseUser, (callback) async {
      if (callback == null) return;
      await initAuthToken();
    });
    // timer = Timer.periodic(45.minutes, (callback) {
    //   initAuthToken();
    // });
    super.onInit();
  }

 

  @override
  void onClose() {
    // timer?.cancel();
    super.onClose();
  }

  Future<void> initAuthToken() async {
    log("updating user token");
    userToken.value = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }

  Future<void> handleEmailVerification() async {
    await 0.milliseconds.delay();
    _isLoading.value = false;
  }

  Future<void> handlePasswordReset(String email) async {
    log('Sending password reset email to $email');
    await _auth.sendPasswordResetEmail(email: email);
  }
}
