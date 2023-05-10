import 'package:cartisan/app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<UserModel?> get usersCollection =>
      _firestore.collection('users').withConverter(
        fromFirestore: (snapshot, options) {
          return snapshot.exists
              ? UserModel.fromMap(snapshot.data() as Map<String, dynamic>)
              : null;
        },
        toFirestore: (object, options) {
          return object!.toMap();
        },
      );
}
