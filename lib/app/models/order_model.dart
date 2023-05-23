// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';

class OrderModel {
  String orderId;
  AddressModel billingAddress;
  AddressModel shippingAddress;
  String buyerId;
  List<OrderItemModel> orderItems = [];
  double total;
  int timestamp;
  List<String> involvedSellersList;
  int totalInCents;
  OrderItemStatus orderStatus;

  String get totalInString {
    return total.toStringAsFixed(2);
  }

  OrderModel({
    required this.orderId,
    required this.billingAddress,
    required this.shippingAddress,
    required this.buyerId,
    required this.orderItems,
    required this.total,
    required this.timestamp,
    required this.involvedSellersList,
    required this.totalInCents,
    required this.orderStatus,
  });

  OrderModel copyWith({
    String? orderId,
    AddressModel? billingAddress,
    AddressModel? shippingAddress,
    String? buyerId,
    List<OrderItemModel>? orderItems,
    double? total,
    int? timestamp,
    List<String>? involvedSellersList,
    int? totalInCents,
    OrderItemStatus? orderStatus,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      buyerId: buyerId ?? this.buyerId,
      orderItems: orderItems ?? this.orderItems,
      total: total ?? this.total,
      timestamp: timestamp ?? this.timestamp,
      involvedSellersList: involvedSellersList ?? this.involvedSellersList,
      totalInCents: totalInCents ?? this.totalInCents,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'billingAddress': billingAddress.toMap(),
      'shippingAddress': shippingAddress.toMap(),
      'buyerId': buyerId,
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
      'total': total,
      'timestamp': timestamp,
      'involvedSellersList': involvedSellersList,
      'totalInCents': totalInCents,
      'orderStatus': orderStatus.index,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final orderItems = <OrderItemModel>[];
    for (final orderItem in map['orderItems'] as List) {
      orderItems.add(OrderItemModel.fromMap(orderItem as Map<String, dynamic>));
    }
    return OrderModel(
      orderId: map['orderId'] as String,
      billingAddress: AddressModel.fromMap(
          (map['billingAddress'] ?? map['address']) as Map<String, dynamic>),
      shippingAddress: AddressModel.fromMap(
          (map['shippingAddress'] ?? map['address']) as Map<String, dynamic>),
      buyerId: map['buyerId'] as String,
      orderItems: orderItems,
      total: (map['total'] as int).toDouble(),
      timestamp: map['timestamp'] as int,
      involvedSellersList: (map['involvedSellersList'] as List).cast<String>(),
      totalInCents: map['totalInCents'] as int,
      orderStatus: OrderItemStatus.values[map['orderStatus'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, billingAddress: $billingAddress, shippingAddress: $shippingAddress, buyerId: $buyerId, orderItems: $orderItems, total: $total, timestamp: $timestamp, involvedSellersList: $involvedSellersList, totalInCents: $totalInCents, orderStatus: $orderStatus)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.billingAddress == billingAddress &&
        other.shippingAddress == shippingAddress &&
        other.buyerId == buyerId &&
        listEquals(other.orderItems, orderItems) &&
        other.total == total &&
        other.timestamp == timestamp &&
        listEquals(other.involvedSellersList, involvedSellersList) &&
        other.totalInCents == totalInCents &&
        other.orderStatus == orderStatus;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        billingAddress.hashCode ^
        shippingAddress.hashCode ^
        buyerId.hashCode ^
        orderItems.hashCode ^
        total.hashCode ^
        timestamp.hashCode ^
        involvedSellersList.hashCode ^
        totalInCents.hashCode ^
        orderStatus.hashCode;
  }
}
