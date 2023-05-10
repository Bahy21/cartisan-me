import 'dart:developer';

import 'package:cartisan/app/repositories/user_repo.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepo _userRepo = UserRepo();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required bool isSeller,
    required double taxPercentage,
    required String city,
    required String country,
    required String state,
  }) async {
    try {
      final creds = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user != null) {
        await creds.user!.updateDisplayName(name);
        final userCollectionRef = UserDatabase().usersCollection;
        final userDoc =
            await userCollectionRef.doc(_firebaseAuth.currentUser!.uid).get();
        if (userDoc.exists) {
          await userCollectionRef.doc(creds.user!.uid).update({
            'isSeller': isSeller,
            'taxPercentage': taxPercentage,
            'city': city,
            'country': country,
            'state': state,
            'username': name,
            'profileName': name,
          });
        } else {
          await Database().userCollection.doc(creds.user!.uid).set({
            'isSeller': isSeller,
            'taxPercentage': taxPercentage,
            'city': city,
            'country': country,
            'state': state,
            'username': name,
            'profileName': name,
          });
        }
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }
}
