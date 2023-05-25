import 'dart:developer';
import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/order_item_status.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

String GET_ORDER = '$BASE_URL/order/getOrder';
String NEW_ORDER = '$BASE_URL/order/newOrder';
String UPDATE_ORDER_STATUS = '$BASE_URL/order/updateOrderStatus';
String UPDATE_ORDER_ITEM_STATUS = '$BASE_URL/order/updateOrderItemStatus';
String CANCEL_ORDER = '$BASE_URL/order/deleteOrder';
String GET_PURCHASED_ORDERS = '$BASE_URL/order/getPurchasedOrders';
String GET_SOLD_ORDERS = '$BASE_URL/order/getSoldOrders';

class OrderAPI {
  final apiService = APIService();

  Future<List<OrderModel>> getPurchasedOrders(String userId) async {
    try {
      final result = await apiService.get<Map>(
        '$GET_PURCHASED_ORDERS/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error getting purchased orders');
      }
      log('purchases $result');
      final data = result.data!['data'] as List;
      final orders = <OrderModel>[];
      for (var item in data) {
        orders.add(OrderModel.fromMap(item as Map<String, dynamic>));
      }
      return orders;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<OrderModel>> getSoldOrders(String userId) async {
    try {
      log('gettng sold orders');
      final result = await apiService.get<Map>(
        '$GET_SOLD_ORDERS/$userId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error getting purchased orders');
      }
      log('sales $result');
      final data = result.data!['data'] as List;
      final orders = <OrderModel>[];
      for (final item in data) {
        orders.add(OrderModel.fromMap(item as Map<String, dynamic>));
      }

      return orders;
    } on Exception catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<OrderModel?> newOrder(AddressModel address) async {
    try {
      final userId = Get.find<AuthService>().currentUser!.uid;
      final result = await apiService.post<Map>(
        '$NEW_ORDER/$userId',
        {'address': address.toMap()},
      );
      if (result.statusCode != 200) {
        throw Exception('Error creating order');
      }
      final data = result.data!['data'] as Map<String, dynamic>;
      return OrderModel.fromMap(data);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> updateOrderStatus({
    required String orderId,
    required OrderItemStatus newSatus,
  }) async {
    try {
      final result = await apiService.put<Map>(
        '$UPDATE_ORDER_STATUS/$orderId',
        {'status': newSatus.index},
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating order status');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      final result = await apiService.delete<Map>(
        '$CANCEL_ORDER/$orderId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error cancelling order');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<OrderModel?> getOrder(String orderId) async {
    try {
      final result = await apiService.get<Map>(
        '$GET_ORDER/$orderId',
      );
      if (result.statusCode != 200) {
        throw Exception('Error fetching order');
      }
      final data = result.data!['data'] as Map<String, dynamic>;
      return OrderModel.fromMap(data);
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> updateOrderItemStatus({
    required String orderId,
    required String orderItemId,
    required OrderItemStatus newStatus,
  }) async {
    try {
      final result = await apiService.put<Map>(
        '$UPDATE_ORDER_ITEM_STATUS/$orderId',
        {'status': newStatus.index, 'orderItemId': orderItemId},
      );
      if (result.statusCode != 200) {
        throw Exception('Error updating order item status');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}
