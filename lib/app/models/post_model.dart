// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cartisan/app/models/delivery_options.dart';

class PostModel {
  String postId;
  String ownerId;
  String description;
  String productName;
  String brand;
  List<String> variants;
  double price;
  String location;
  double rating;
  List<String> images;
  String selectedVariant;
  int quantity;
  bool isProductInStock;
  bool archived;
  int sellCount;
  int commentCount;
  int reviewCount;
  int likesCount;
  DeliveryOptions deliveryOptions;

  int get priceInCents => (price * 100).toInt();

  PostModel({
    required this.postId,
    required this.ownerId,
    required this.description,
    required this.productName,
    required this.brand,
    required this.variants,
    required this.price,
    required this.location,
    required this.rating,
    required this.images,
    required this.selectedVariant,
    required this.quantity,
    required this.isProductInStock,
    required this.archived,
    required this.sellCount,
    required this.commentCount,
    required this.reviewCount,
    required this.likesCount,
    required this.deliveryOptions,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] as String,
      ownerId: map['ownerId'] as String,
      description: map['description'] as String,
      productName: map['productName'] as String,
      brand: map['brand'] as String,
      variants: (map['variants'] as List<dynamic>).cast<String>(),
      price: (map['price'] as num).toDouble(),
      location: map['location'] as String,
      rating: (map['rating'] as num).toDouble(),
      images: (map['images'] as List<dynamic>).cast<String>(),
      selectedVariant: map['selectedVariant'] as String,
      quantity: map['quantity'] as int,
      isProductInStock: map['isProductInStock'] as bool,
      archived: map['archived'] as bool,
      sellCount: map['sellCount'] as int,
      commentCount: map['commentCount'] as int,
      reviewCount: map['reviewCount'] as int,
      likesCount: map['likesCount'] as int,
      deliveryOptions: DeliveryOptions.values[map['deliveryOptions'] as int],
    );
  }

  PostModel copyWith({
    String? postId,
    String? ownerId,
    String? description,
    String? productName,
    String? brand,
    List<String>? variants,
    double? price,
    String? location,
    double? rating,
    List<String>? images,
    String? selectedVariant,
    int? quantity,
    bool? isProductInStock,
    bool? archived,
    int? sellCount,
    int? commentCount,
    int? reviewCount,
    int? likesCount,
    DeliveryOptions? deliveryOptions,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      variants: variants ?? this.variants,
      price: price ?? this.price,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      quantity: quantity ?? this.quantity,
      isProductInStock: isProductInStock ?? this.isProductInStock,
      archived: archived ?? this.archived,
      sellCount: sellCount ?? this.sellCount,
      commentCount: commentCount ?? this.commentCount,
      reviewCount: reviewCount ?? this.reviewCount,
      likesCount: likesCount ?? this.likesCount,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'ownerId': ownerId,
      'description': description,
      'productName': productName,
      'brand': brand,
      'variants': variants,
      'price': price,
      'location': location,
      'rating': rating,
      'images': images,
      'selectedVariant': selectedVariant,
      'quantity': quantity,
      'isProductInStock': isProductInStock,
      'archived': archived,
      'sellCount': sellCount,
      'commentCount': commentCount,
      'reviewCount': reviewCount,
      'likesCount': likesCount,
      'deliveryOptions': deliveryOptions,
    };
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(postId: $postId, ownerId: $ownerId, description: $description, productName: $productName, brand: $brand, variants: $variants, price: $price, location: $location, rating: $rating, images: $images, selectedVariant: $selectedVariant, quantity: $quantity, isProductInStock: $isProductInStock, archived: $archived, sellCount: $sellCount, commentCount: $commentCount, reviewCount: $reviewCount, likesCount: $likesCount, deliveryOptions: $deliveryOptions)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.ownerId == ownerId &&
        other.description == description &&
        other.productName == productName &&
        other.brand == brand &&
        listEquals(other.variants, variants) &&
        other.price == price &&
        other.location == location &&
        other.rating == rating &&
        listEquals(other.images, images) &&
        other.selectedVariant == selectedVariant &&
        other.quantity == quantity &&
        other.isProductInStock == isProductInStock &&
        other.archived == archived &&
        other.sellCount == sellCount &&
        other.commentCount == commentCount &&
        other.reviewCount == reviewCount &&
        other.likesCount == likesCount &&
        other.deliveryOptions == deliveryOptions;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        ownerId.hashCode ^
        description.hashCode ^
        productName.hashCode ^
        brand.hashCode ^
        variants.hashCode ^
        price.hashCode ^
        location.hashCode ^
        rating.hashCode ^
        images.hashCode ^
        selectedVariant.hashCode ^
        quantity.hashCode ^
        isProductInStock.hashCode ^
        archived.hashCode ^
        sellCount.hashCode ^
        commentCount.hashCode ^
        reviewCount.hashCode ^
        likesCount.hashCode ^
        deliveryOptions.hashCode;
  }
}
