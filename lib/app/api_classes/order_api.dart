import 'package:cartisan/app/api_classes/api_service.dart';

String getOrderItems(String orderId) => '$BASE_URL/order/getOrders/$orderId';
String createOrder(String userId) => '$BASE_URL/order/newOrder/$userId';
String updateOrderStatus(String orderId) =>
    '$BASE_URL/order/updateOrderStatus/$orderId';
String updateOrderItemStatus(String orderId) =>
    '$BASE_URL/order/updateOrderItemStatus/$orderId';
String cancelOrder(String orderId) => '$BASE_URL/order/deleteOrder/$orderId';

class OrderAPI {}
