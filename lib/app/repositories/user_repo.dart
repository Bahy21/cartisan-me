import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepo {
  final userDb = UserDatabase();
  final userApi = UserAPI();
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;

  Stream<UserModel?> currentUserStream() {
    return userDb.usersCollection
        .doc(_currentUid)
        .snapshots()
        .map((event) => event.data());
  }
}
