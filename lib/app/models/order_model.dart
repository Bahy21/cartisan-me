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
}
