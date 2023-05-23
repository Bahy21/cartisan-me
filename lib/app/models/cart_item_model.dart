// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:flutter/foundation.dart';

class CartItemModel {
  String cartItemId;
  String postId;
  String sellerId;
  String username;
  String description;
  String productname;
  String brand;
  DeliveryOptions? deliveryOptions;

  /// Price in USD.
  late double price;
  late double discount;

  /// Price in Cents.
  int priceInCents;
  int discountInCents;
  List<String> images;
  String selectedVariant;
  List<String> variants;
  int quantity;

  Database db = Database();

  int get netPriceInCents => priceInCents - discountInCents;
  double get netPrice => price - discount;

  CartItemModel({
    required this.cartItemId,
    required this.postId,
    required this.sellerId,
    required this.username,
    required this.description,
    required this.productname,
    required this.brand,
    required this.deliveryOptions,
    required this.price,
    required this.discount,
    required this.priceInCents,
    required this.discountInCents,
    required this.images,
    required this.selectedVariant,
    required this.variants,
    required this.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      cartItemId: map['cartItemId'] as String,
      postId: map['postId'] as String,
      sellerId: map['sellerId'] as String,
      username: map['username'] as String,
      description: map['description'] as String,
      productname: map['productname'] as String,
      brand: map['brand'] as String,
      deliveryOptions: map['deliveryOptions'] != null
          ? DeliveryOptions.values[map['deliveryOptions'] as int]
          : null,
      price: (map['price'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      priceInCents: map['priceInCents'] as int,
      discountInCents: map['discountInCents'] as int,
      images: (map['images'] as List<dynamic>).cast<String>(),
      selectedVariant: map['selectedVariant'] as String,
      variants: (map['variants'] as List<dynamic>).cast<String>(),
      quantity: map['quantity'] as int,
    );
  }

  CartItemModel copyWith({
    String? cartItemId,
    String? postId,
    String? sellerId,
    String? username,
    String? description,
    String? productname,
    String? brand,
    DeliveryOptions? deliveryOptions,
    double? price,
    double? discount,
    int? priceInCents,
    int? discountInCents,
    List<String>? images,
    String? selectedVariant,
    List<String>? variants,
    int? quantity,
  }) {
    return CartItemModel(
      cartItemId: cartItemId ?? this.cartItemId,
      postId: postId ?? this.postId,
      sellerId: sellerId ?? this.sellerId,
      username: username ?? this.username,
      description: description ?? this.description,
      productname: productname ?? this.productname,
      brand: brand ?? this.brand,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      priceInCents: priceInCents ?? this.priceInCents,
      discountInCents: discountInCents ?? this.discountInCents,
      images: images ?? this.images,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      variants: variants ?? this.variants,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartItemId': cartItemId,
      'postId': postId,
      'sellerId': sellerId,
      'username': username,
      'description': description,
      'productname': productname,
      'brand': brand,
      'deliveryOptions': deliveryOptions,
      'price': price,
      'discount': discount,
      'priceInCents': priceInCents,
      'discountInCents': discountInCents,
      'images': images,
      'selectedVariant': selectedVariant,
      'variants': variants,
      'quantity': quantity,
    };
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartItemModel(cartItemId: $cartItemId, postId: $postId, sellerId: $sellerId, username: $username, description: $description, productname: $productname, brand: $brand, deliveryOptions: $deliveryOptions, price: $price, discount: $discount, priceInCents: $priceInCents, discountInCents: $discountInCents, images: $images, selectedVariant: $selectedVariant, variants: $variants, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant CartItemModel other) {
    if (identical(this, other)) return true;

    return other.cartItemId == cartItemId &&
        other.postId == postId &&
        other.sellerId == sellerId &&
        other.username == username &&
        other.description == description &&
        other.productname == productname &&
        other.brand == brand &&
        other.deliveryOptions == deliveryOptions &&
        other.price == price &&
        other.discount == discount &&
        other.priceInCents == priceInCents &&
        other.discountInCents == discountInCents &&
        listEquals(other.images, images) &&
        other.selectedVariant == selectedVariant &&
        listEquals(other.variants, variants) &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return cartItemId.hashCode ^
        postId.hashCode ^
        sellerId.hashCode ^
        username.hashCode ^
        description.hashCode ^
        productname.hashCode ^
        brand.hashCode ^
        deliveryOptions.hashCode ^
        price.hashCode ^
        discount.hashCode ^
        priceInCents.hashCode ^
        discountInCents.hashCode ^
        images.hashCode ^
        selectedVariant.hashCode ^
        variants.hashCode ^
        quantity.hashCode;
  }
}
