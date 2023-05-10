import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/cart_Item_model.dart';
import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
// import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserModel {
  final String id;
  final String profileName;
  final String username;
  final String email;

  int unreadMessageCount;

  /// Tax value in that state.
  double? taxPercentage;
  String url;
  String? bio;

  /// Cost in USD to ship to customer. Set by seller.
  double? shippingCost;

  /// Cost in USD to deliver to customer.
  double? deliveryCost;

  double freeShipping;
  double freeDelivery;
  bool activeShipping = false;
  bool pickup = true;
  bool isDeliveryAvailable = false;
  String sellerID;
  String buyerID;
  AddressModel? defaultAddress;
  String country;
  String state;
  String city;
  bool? isSeller;

  String customerId;

  String uniqueStoreName;
  int followerCount;
  int followingCount;
  Database db = Database();

  /// Cost in Cents to ship to customer.
  int get shippingCostInCents => (shippingCost! * 100).floor();

  /// Cost in Cents to ship to deliver to the customer.
  int get deliveryCostInCents => (deliveryCost! * 100).floor();

  bool get setupComplete {
    if (city.isNotEmpty && country.isNotEmpty && state.isNotEmpty) {
      return true;
    }
    return false;
  }

  UserModel({
    required this.id,
    required this.username,
    required this.url,
    required this.email,
    this.unreadMessageCount = 0,
    this.profileName = '',
    this.customerId = '',
    this.taxPercentage = 0.0,
    this.bio = '',
    this.shippingCost = 0.0,
    this.deliveryCost = 0.0,
    this.freeShipping = 0.0,
    this.freeDelivery = 0.0,
    this.activeShipping = false,
    this.pickup = false,
    this.isDeliveryAvailable = false,
    this.sellerID = '',
    this.buyerID = '',
    this.defaultAddress,
    this.country = '',
    this.state = '',
    this.city = '',
    this.isSeller,
    this.uniqueStoreName = '',
    this.followerCount = 0,
    this.followingCount = 0,
  });

  @override
  String toString() {
    return '''UserModel(id: $id, profileName: $profileName, taxPercentage: $taxPercentage, username: $username, url: $url, email: $email, bio: $bio, shippingCost: $shippingCost, deliveryCost: $deliveryCost, freeShipping: $freeShipping, freeDelivery: $freeDelivery,  activeShipping: $activeShipping, pickup: $pickup, isDeliveryAvailable: $isDeliveryAvailable, sellerID: $sellerID, buyerID: $buyerID, defaultAddress: $defaultAddress, country: $country, state: $state, city: $city, uniqueStoreName: $uniqueStoreName)''';
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.profileName == profileName &&
        other.taxPercentage == taxPercentage &&
        other.username == username &&
        other.url == url &&
        other.email == email &&
        other.bio == bio &&
        other.shippingCost == shippingCost &&
        other.deliveryCost == deliveryCost &&
        other.freeShipping == freeShipping &&
        other.freeDelivery == freeDelivery &&
        other.activeShipping == activeShipping &&
        other.pickup == pickup &&
        other.isDeliveryAvailable == isDeliveryAvailable &&
        other.sellerID == sellerID &&
        other.buyerID == buyerID &&
        other.defaultAddress == defaultAddress &&
        other.country == country &&
        other.state == state &&
        other.city == city &&
        other.uniqueStoreName == uniqueStoreName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        profileName.hashCode ^
        taxPercentage.hashCode ^
        username.hashCode ^
        url.hashCode ^
        email.hashCode ^
        bio.hashCode ^
        shippingCost.hashCode ^
        deliveryCost.hashCode ^
        freeShipping.hashCode ^
        freeDelivery.hashCode ^
        activeShipping.hashCode ^
        pickup.hashCode ^
        isDeliveryAvailable.hashCode ^
        sellerID.hashCode ^
        buyerID.hashCode ^
        defaultAddress.hashCode ^
        country.hashCode ^
        state.hashCode ^
        city.hashCode ^
        uniqueStoreName.hashCode;
  }

  factory UserModel.fromDocument(DocumentSnapshot documentSnapshot) {
    if (!documentSnapshot.exists) throw Exception('No user found');

    final doc = documentSnapshot.data() as Map<String, dynamic>;
    final user = UserModel(
      unreadMessageCount: doc['unreadMessageCount'] as int? ?? 0,
      defaultAddress: (doc['defaultAddress'] as AddressModel?) == null
          ? null
          : AddressModel.fromMap(doc['defaultAddress'] as Map<String, dynamic>),
      id: documentSnapshot.id,
      email: doc['email'] as String? ?? '',
      username: doc['uniqueStoreName'] as String? ?? '',
      url: doc['url'] as String? ?? '',
      profileName: doc['profileName'] as String? ?? '',
      bio: doc['bio'] as String? ?? '',
      customerId: doc['customer_id'] as String? ?? '',
      shippingCost: doc['shippingCost'] as double? ?? 0.0,
      deliveryCost: doc['deliveryCost'] as double? ?? 0.0,
      freeShipping: doc['freeShipping'] as double? ?? 0.0,
      freeDelivery: doc['freeDelivery'] as double? ?? 0.0,
      activeShipping: doc['activeShipping'] as bool? ?? false,
      pickup: doc['pickup'] as bool? ?? true,
      sellerID: doc['sellerID'] as String? ?? '',
      isDeliveryAvailable: doc['isDeliveryAvailable'] as bool? ?? false,
      taxPercentage: doc['taxPercentage'] as double? ?? 0.0,
      buyerID: doc['buyerID'] as String? ?? '',
      city: doc['city'] as String? ?? '',
      country: doc['country'] as String? ?? '',
      state: doc['state'] as String? ?? '',
      isSeller: doc['isSeller'] as bool? ?? false,
      uniqueStoreName: doc['uniqueStoreName'] as String? ?? '',
      followerCount: doc['followerCount'] as int? ?? 0,
      followingCount: doc['followingCount'] as int? ?? 0,
    );

    return user;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      unreadMessageCount: map['unreadMessageCount'] as int? ?? 0,
      id: map['id'] as String? ?? '',
      profileName: map['profileName'] as String? ?? '',
      taxPercentage: map['taxPercentage'] != null
          ? (map['taxPercentage'] as num).toDouble()
          : 0.0,
      username: map['username'] as String? ?? '',
      url: map['url'] as String? ?? '',
      email: map['email'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      customerId:
          map['customer_id'] as String? ?? map['buyerID'] as String? ?? '',
      shippingCost: map['shippingCost'] != null
          ? (map['shippingCost'] as num).toDouble()
          : 0.0,
      deliveryCost: map['deliveryCost'] != null
          ? (map['deliveryCost'] as num).toDouble()
          : 0.0,
      freeShipping: map['freeShipping'] != null
          ? (map['freeShipping'] as num).toDouble()
          : 0.0,
      freeDelivery: map['freeDelivery'] != null
          ? (map['freeDelivery'] as num).toDouble()
          : 0.0,
      activeShipping: map['activeShipping'] as bool? ?? false,
      pickup: map['pickup'] as bool? ?? true,
      isDeliveryAvailable: map['isDeliveryAvailable'] as bool? ?? false,
      sellerID: map['sellerID'] as String? ?? '',
      buyerID: map['buyerID'] as String? ?? '',
      defaultAddress: map['defaultAddress'] == null
          ? null
          : AddressModel.fromMap(map['defaultAddress'] as Map<String, dynamic>),
      country: map['country'] as String? ?? '',
      state: map['state'] as String? ?? '',
      city: map['city'] as String? ?? '',
      uniqueStoreName: map['uniqueStoreName'] as String? ?? '',
      isSeller: map['isSeller'] as bool? ?? false,
      followerCount: map['followerCount'] as int? ?? 0,
      followingCount: map['followingCount'] as int? ?? 0,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /*
  ChatUser getChatUser() {
    return ChatUser(
      avatar: url,
      name: profileName,
      uid: id,
    );
  }
  */

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profileName': profileName,
      'taxPercentage': taxPercentage,
      'username': username,
      'url': url,
      'email': email,
      'bio': bio,
      'shippingCost': shippingCost,
      'deliveryCost': deliveryCost,
      'freeShipping': freeShipping,
      'freeDelivery': freeDelivery,
      'activeShipping': activeShipping,
      'pickup': pickup,
      'isDeliveryAvailable': isDeliveryAvailable,
      'sellerID': sellerID,
      'isSeller': isSeller,
      'buyerID': buyerID,
      'defaultAddress': defaultAddress?.toMap(),
      'country': country,
      'state': state,
      'city': city,
      'uniqueStoreName': uniqueStoreName,
      'followerCount': followerCount,
      'followingCount': followingCount,
    };
  }

  Map<String, dynamic> toAlgolia() {
    return <String, dynamic>{
      'objectID': id,
      'id': id,
      'profileName': profileName,
      'username': username,
      'url': url,
      'email': email,
      'bio': bio,
      'shippingCost': shippingCost,
      'deliveryCost': deliveryCost,
      'freeShipping': freeShipping,
      'freeDelivery': freeDelivery,
      'uniqueStoreName': uniqueStoreName,
      'followerCount': followerCount,
      'followingCount': followingCount,
    };
  }

  /*
  Future<bool> checkIfStripeSetupIsComplete() async {
    if (sellerID.isEmpty) return false;
    final HttpsCallable getCapability =
        FirebaseFunctions.instance.httpsCallable('stripeApp-getCapability');
    final response = await getCapability.call(<String, dynamic>{
      'accountID': sellerID,
    });
    if (response.data['status'] == "active") {
      return true;
    } else {
      return false;
    }
  }

  Stream<String> stripeAccountStream() {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('users').doc(id);
    return reference.snapshots().map((snapshot) {
      sellerID = snapshot.get("sellerID");
      return sellerID;
    });
  }
  */
  UserModel copyWith({
    String? id,
    String? profileName,
    double? taxPercentage,
    String? username,
    String? url,
    String? email,
    String? bio,
    double? shippingCost,
    double? deliveryCost,
    double? freeShipping,
    double? freeDelivery,
    bool? activeShipping,
    bool? pickup,
    bool? isDeliveryAvailable,
    String? sellerID,
    String? buyerID,
    AddressModel? defaultAddress,
    String? country,
    String? state,
    String? city,
    bool? isSeller,
    String? uniqueStoreName,
  }) {
    return UserModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      username: username ?? this.username,
      url: url ?? this.url,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      shippingCost: shippingCost ?? this.shippingCost,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      freeShipping: freeShipping ?? this.freeShipping,
      freeDelivery: freeDelivery ?? this.freeDelivery,
      activeShipping: activeShipping ?? this.activeShipping,
      pickup: pickup ?? this.pickup,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      sellerID: sellerID ?? this.sellerID,
      buyerID: buyerID ?? this.buyerID,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      isSeller: isSeller ?? this.isSeller,
      uniqueStoreName: uniqueStoreName ?? this.uniqueStoreName,
    );
  }

  String toJson() => json.encode(toMap());
}
