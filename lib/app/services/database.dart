import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final firestore = FirebaseFirestore.instance;
  // User collection.
  CollectionReference get userCollection => firestore.collection('users');
  // Post collection.
  CollectionReference get postsCollection => firestore.collection('posts');
  // Order collection.
  CollectionReference get ordersCollection => firestore.collection('orders');
  // All active carts subcollections.
  Query get activeCartCollectionGroup => firestore.collectionGroup('cart');
  // User Reports collection.
  CollectionReference get userReportsCollection =>
      firestore.collection('userReport');
  // Debug Reports collection.
  CollectionReference get errorReportReference =>
      firestore.collection('errorReports');

  void get addCardtoUser => log('Not implemented yet');

  // User subcollections.
  CollectionReference<Map<String, dynamic>> allUserAddresses(String userId) =>
      userCollection.doc(userId).collection('addresses');
  CollectionReference<Map<String, dynamic>> userBlockedUsersCollection(
    String userId,
  ) =>
      userCollection.doc(userId).collection('blockedUsers');
  CollectionReference<Map<String, dynamic>> userFollowingCollection(
    String userId,
  ) =>
      userCollection.doc(userId).collection('userFollowing');
  CollectionReference<Map<String, dynamic>> userFollowersCollection(
    String userId,
  ) =>
      userCollection.doc(userId).collection('userFollowers');
  CollectionReference<Map<String, dynamic>> userCartCollection(String userId) =>
      userCollection.doc(userId).collection('cart');
  CollectionReference<Map<String, dynamic>> userNotificationCollection(
    String userId,
  ) =>
      userCollection.doc(userId).collection('notifications');

  // Post subcollections.
  CollectionReference<Map<String, dynamic>> reviewCollection(String postId) =>
      postsCollection.doc(postId).collection('reviews');
  CollectionReference<Map<String, dynamic>> likesCollection(String postId) =>
      postsCollection.doc(postId).collection('likes');
  CollectionReference<Map<String, dynamic>> commentsCollection(String postId) =>
      postsCollection.doc(postId).collection('comments');

  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final storagePlace = storageRef.child(
        'profile_images/${DateTime.now().millisecondsSinceEpoch}-${image.path}',
      );
      await storagePlace.putFile(image);
      final url = await storagePlace.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
