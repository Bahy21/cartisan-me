// import 'package:cartisan_getx/app/models/address_model.dart';
// import 'package:cartisan_getx/app/models/user.dart';
import 'dart:developer';

import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;
  Database db = Database();

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> signUp({
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
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() async {
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          final newUserId = currentUser.uid;
          log('user created with id:$newUserId');
          final address = AddressModel(
            userID: newUserId,
            addressID: '',
            addressLine1: '',
            addressLine2: '',
            addressLine3: '',
            postalCode: '',
            contactNumber: '',
            fullname: '',
            city: city,
            state: state,
          );
          final userModel = UserModel(
            id: newUserId,
            profileName: name,
            taxPercentage: taxPercentage,
            username: name,
            url: '',
            email: email,
            defaultAddress: address,
            country: country,
            state: state,
            city: city,
            isSeller: isSeller,
          );
          try {
            await db.userCollection.doc(newUserId).set(userModel.toMap());
            // TODO: ADD THE FOLLOW CALL HERE.

            update();
          } on FirebaseAuthException catch (e) {
            Get.snackbar("Error", e.message!,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.white);
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message!,
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Get.snackbar(
        'Please wait.',
        'Logging In...',
        snackPosition: SnackPosition.BOTTOM,
        barBlur: 1.0,
        backgroundColor: Colors.white,
      );
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      update();
      log('username is : ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error signing in',
        e.message!,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
      );
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      Get
        ..snackbar(
          'Error',
          e.message!,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
        )
        ..back<void>();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error signing out',
        e.message ?? 'Error signing out',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
