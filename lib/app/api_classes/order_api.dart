import 'dart:convert';
import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_model.dart';

const String GET_ORDER_ITEMS = '$BASE_URL/order/getOrders';
String createOrder(String userId) => '$BASE_URL/order/newOrder/$userId';
String updateOrderStatus(String orderId) =>
    '$BASE_URL/order/updateOrderStatus/$orderId';
String updateOrderItemStatus(String orderId) =>
    '$BASE_URL/order/updateOrderItemStatus/$orderId';
String cancelOrder(String orderId) => '$BASE_URL/order/deleteOrder/$orderId';

class OrderAPI {
  final apiService = APIService();

  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    try {
      final result = await apiService.get<String>(
        '$GET_ORDER_ITEMS/$orderId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching user');
      }
      final data = jsonDecode(result.data.toString()) as List;
      final orderItems = <OrderItemModel>[];
      for (final orderItem in data) {
        orderItems
            .add(OrderItemModel.fromMap(orderItem as Map<String, dynamic>));
      }
      return orderItems;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }
}
