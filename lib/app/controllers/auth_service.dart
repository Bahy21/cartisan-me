import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> firebaseUser = Rx<User?>(null);

  User? get user => firebaseUser.value;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  // ignore: prefer_final_fields
  RxBool _isLoading = true.obs;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    handleEmailVerification();
    super.onInit();
  }

  void handleEmailVerification() {
    100.milliseconds.delay().then((dynamic _) => _isLoading.value = false);
  }
}
