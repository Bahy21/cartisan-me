// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cartisan/app/models/delivery_options.dart';
import 'package:cartisan/app/models/order_item_status.dart';

class OrderItemModel {
  String orderItemID;
  String productId;
  String selectedVariant;
  int appFeeInCents;
  int quantity;
  double price;
  int grossTotalInCents;
  String sellerId;
  DeliveryOptions deliveryOption;
  int deliveryCostInCents;
  int costBeforeTaxInCents;
  int serviceFeeInCents;
  String sellerStripeId;
  double tax;
  OrderItemStatus status;

  double get grossTotal {
    return grossTotalInCents / 100;
  }

  String get grossTotalString {
    return (grossTotalInCents / 100).toStringAsFixed(2);
  }

  double get deliveryCost {
    return deliveryCostInCents / 100;
  }

  String get deliveryCostString {
    return (deliveryCostInCents / 100).toStringAsFixed(2);
  }

  double get costBeforeTax {
    return costBeforeTaxInCents / 100;
  }

  OrderItemModel({
    required this.orderItemID,
    required this.productId,
    required this.selectedVariant,
    required this.appFeeInCents,
    required this.quantity,
    required this.price,
    required this.grossTotalInCents,
    required this.sellerId,
    required this.deliveryOption,
    required this.deliveryCostInCents,
    required this.costBeforeTaxInCents,
    required this.serviceFeeInCents,
    required this.tax,
    required this.status,
    this.sellerStripeId = '',
  });

  OrderItemModel copyWith({
    String? orderItemID,
    String? productId,
    String? selectedVariant,
    int? appFeeInCents,
    int? quantity,
    double? price,
    int? grossTotalInCents,
    String? sellerId,
    DeliveryOptions? deliveryOption,
    int? deliveryCostInCents,
    int? costBeforeTaxInCents,
    int? serviceFeeInCents,
    String? sellerStripeId,
    double? tax,
    OrderItemStatus? status,
  }) {
    return OrderItemModel(
      orderItemID: orderItemID ?? this.orderItemID,
      productId: productId ?? this.productId,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      appFeeInCents: appFeeInCents ?? this.appFeeInCents,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      grossTotalInCents: grossTotalInCents ?? this.grossTotalInCents,
      sellerId: sellerId ?? this.sellerId,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      deliveryCostInCents: deliveryCostInCents ?? this.deliveryCostInCents,
      costBeforeTaxInCents: costBeforeTaxInCents ?? this.costBeforeTaxInCents,
      serviceFeeInCents: serviceFeeInCents ?? this.serviceFeeInCents,
      sellerStripeId: sellerStripeId ?? this.sellerStripeId,
      tax: tax ?? this.tax,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemID': orderItemID,
      'productId': productId,
      'selectedVariant': selectedVariant,
      'appFeeInCents': appFeeInCents,
      'quantity': quantity,
      'price': price,
      'grossTotalInCents': grossTotalInCents,
      'sellerId': sellerId,
      'deliveryOption': deliveryOption,
      'deliveryCostInCents': deliveryCostInCents,
      'costBeforeTaxInCents': costBeforeTaxInCents,
      'serviceFeeInCents': serviceFeeInCents,
      'sellerStripeId': sellerStripeId,
      'tax': tax,
      'status': status,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      orderItemID: map['orderItemID'] as String,
      productId: map['productId'] as String,
      selectedVariant: map['selectedVariant'] as String,
      appFeeInCents: map['appFeeInCents'] as int,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      grossTotalInCents: map['grossTotalInCents'] as int,
      sellerId: map['sellerId'] as String,
      deliveryOption: DeliveryOptions.values[map['deliveryOption'] as int],
      deliveryCostInCents: map['deliveryCostInCents'] as int,
      costBeforeTaxInCents: map['costBeforeTaxInCents'] as int,
      serviceFeeInCents: map['serviceFeeInCents'] as int,
      sellerStripeId: map['sellerStripeId'] as String,
      tax: map['tax'] as double,
      status: OrderItemStatus.values[map['status'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderItemModel(orderItemID: $orderItemID, productId: $productId, selectedVariant: $selectedVariant, appFeeInCents: $appFeeInCents, quantity: $quantity, price: $price, grossTotalInCents: $grossTotalInCents, sellerId: $sellerId, deliveryOption: $deliveryOption, deliveryCostInCents: $deliveryCostInCents, costBeforeTaxInCents: $costBeforeTaxInCents, serviceFeeInCents: $serviceFeeInCents, sellerStripeId: $sellerStripeId, tax: $tax, status: $status)';
  }

  @override
  bool operator ==(covariant OrderItemModel other) {
    if (identical(this, other)) return true;

    return other.orderItemID == orderItemID &&
        other.productId == productId &&
        other.selectedVariant == selectedVariant &&
        other.appFeeInCents == appFeeInCents &&
        other.quantity == quantity &&
        other.price == price &&
        other.grossTotalInCents == grossTotalInCents &&
        other.sellerId == sellerId &&
        other.deliveryOption == deliveryOption &&
        other.deliveryCostInCents == deliveryCostInCents &&
        other.costBeforeTaxInCents == costBeforeTaxInCents &&
        other.serviceFeeInCents == serviceFeeInCents &&
        other.sellerStripeId == sellerStripeId &&
        other.tax == tax &&
        other.status == status;
  }

  @override
  int get hashCode {
    return orderItemID.hashCode ^
        productId.hashCode ^
        selectedVariant.hashCode ^
        appFeeInCents.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        grossTotalInCents.hashCode ^
        sellerId.hashCode ^
        deliveryOption.hashCode ^
        deliveryCostInCents.hashCode ^
        costBeforeTaxInCents.hashCode ^
        serviceFeeInCents.hashCode ^
        sellerStripeId.hashCode ^
        tax.hashCode ^
        status.hashCode;
  }
}
