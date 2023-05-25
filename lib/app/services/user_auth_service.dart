import 'dart:developer';

import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      await showErrorDialog('Error signing in\n ${e.message}');
    }
  }

  Future<bool> signUpWithEmailAndPassword({
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
        final id = _firebaseAuth.currentUser!.uid;
        await creds.user!.updateDisplayName(name);
        final userCollectionRef = UserDatabase().usersCollection;
        final userDoc = userCollectionRef.doc(id);
        final newUser = await initFirebaseUser(
          email: email,
          name: name,
          isSeller: isSeller,
          taxPercentage: taxPercentage,
          city: city,
          country: country,
          state: state,
          id: id,
        );
        await userDoc.set(newUser);
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  Future<UserModel> initFirebaseUser({
    required String email,
    required String name,
    required bool isSeller,
    required double taxPercentage,
    required String city,
    required String country,
    required String state,
    required String id,
  }) async {
    final newUser = UserModel(id: id, username: name, url: '', email: email);
    newUser.profileName = name;
    newUser.unreadMessageCount = 0;
    newUser.taxPercentage = taxPercentage;
    newUser.bio = '';
    newUser.shippingCost = 0;
    newUser.deliveryCost = 0;
    newUser.freeShipping = 0;
    newUser.freeDelivery = 0;
    newUser.activeShipping = false;
    newUser.pickup = false;
    newUser.isDeliveryAvailable = false;
    newUser.sellerID = '';
    newUser.buyerID = '';
    final defAddress = AddressModel(
      userID: id,
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
    newUser.defaultAddress = defAddress;
    newUser.country = country;
    newUser.state = defAddress.state;
    newUser.city = defAddress.city;
    newUser.isSeller = isSeller;
    newUser.customerId = '';
    newUser.uniqueStoreName = '';
    return newUser;
  }
}
