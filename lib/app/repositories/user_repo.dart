import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final userDb = UserDatabase();
  final Database _database = Database();
  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;

  Stream<UserModel?> currentUserStream() {
    return userDb.usersCollection
        .doc(_currentUid)
        .snapshots()
        .map((event) => event.data());
  }
}
