import 'dart:convert';
import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/services/database.dart';

class CartItemModel {
  String itemId;
  String postId;
  String ownerId;
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
  String variant;
  List<String> variants;
  int quantity;

  Database db = Database();

  int get netPriceInCents => priceInCents - discountInCents;
  double get netPrice => price - discount;

  CartItemModel({
    required this.itemId,
    required this.postId,
    required this.ownerId,
    required this.description,
    required this.productname,
    required this.brand,
    required this.deliveryOptions,
    required this.price,
    required this.discount,
    required this.priceInCents,
    required this.discountInCents,
    required this.images,
    required this.variant,
    required this.quantity,
    required this.variants,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      itemId: map['itemId'] as String,
      postId: map['postId'] as String,
      ownerId: map['ownerId'] as String,
      description: map['description'] as String,
      productname: map['productname'] as String,
      brand: map['brand'] as String,
      price: map['price'] as double,
      discount: map['discount'] as double,
      priceInCents: map['priceInCents'] as int,
      discountInCents: map['discountInCents'] as int,
      images: map['images'] as List<String>,
      variant: map['variant'] as String,
      quantity: map['quantity'] as int,
      variants: map['variants'] as List<String>,
      deliveryOptions: map['deliveryOptions'] != null
          ? DeliveryOptions.values[map['deliveryOptions'] as int]
          : null,
    );
  }

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CartItemModel fromPost(PostModel post) {
    return CartItemModel(
      itemId: '',
      postId: post.postId,
      ownerId: post.ownerId,
      description: post.description,
      productname: post.productName,
      brand: post.brand,
      price: post.price,
      discount: 0,
      priceInCents: (price * 100).toInt(),
      discountInCents: (discount * 100).toInt(),
      images: post.images,
      quantity: post.quantity,
      variant: post.selectedVariant,
      variants: post.variants,
      deliveryOptions: post.deliveryOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'postId': postId,
      'ownerId': ownerId,
      'description': description,
      'productname': productname,
      'brand': brand,
      'price': price,
      'discount': discount,
      'priceInCents': priceInCents,
      'discountInCents': discountInCents,
      'images': images,
      'variant': variant,
      'quantity': quantity,
      'variants': variants,
      'deliveryOptions':
          deliveryOptions != null ? deliveryOptions!.index : null,
    };
  }

  String toJson() => json.encode(toMap());

  CartItemModel copyWith({
    String? itemId,
    String? postId,
    String? ownerId,
    String? description,
    String? productname,
    String? brand,
    DeliveryOptions? deliveryOptions,
    double? price,
    double? discount,
    int? priceInCents,
    int? discountInCents,
    List<String>? images,
    List<String>? options,
    String? option,
    int? quantity,
  }) {
    return CartItemModel(
      itemId: itemId ?? this.itemId,
      postId: postId ?? this.postId,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      productname: productname ?? this.productname,
      brand: brand ?? this.brand,
      deliveryOptions: deliveryOptions ?? this.deliveryOptions,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      priceInCents: priceInCents ?? this.priceInCents,
      discountInCents: discountInCents ?? this.discountInCents,
      images: images ?? this.images,
      variants: options ?? this.variants,
      variant: option ?? this.variant,
      quantity: quantity ?? this.quantity,
    );
  }

  Future<int> getDeliveryCostInCents() async {
    final doc = await db.userCollection.doc(ownerId).get();
    final user = UserModel.fromDocument(doc);
    switch (deliveryOptions) {
      case DeliveryOptions.pickup:
        return 0;

      case DeliveryOptions.delivery:
        return user.deliveryCostInCents;

      case DeliveryOptions.shipping:
        return user.shippingCostInCents;

      default:
        return 0;
    }
  }
}
