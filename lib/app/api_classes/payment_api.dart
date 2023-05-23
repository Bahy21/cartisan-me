// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:cartisan/app/api_classes/api_service.dart';

String CREATE_PAYMENT_INTENT = '$BASE_URL/payment/stripe/createPaymentIntent';
String CANCEL_AND_REFUND = '$BASE_URL/payment/stripe/cancelItemAndRefund';
String DELETE_ACCOUNT = '$BASE_URL/payment/stripe/deleteConnectAccount';
String CREATE_ACCOUNT = '$BASE_URL/payment/stripe/connectStripeExpressAccount';
String CHECK_IF_STRIPE_SETUP_COMPLETE =
    '$BASE_URL/payment/stripe/getCapability';
String GET_DASHBOARD_URL = '$BASE_URL/payment/stripe/getDashboardLink';

class PaymentAPI {
  final apiService = APIService();

  Future<String> getDashboardLink(String sellerId) async {
    try {
      final result = await apiService.get<Map>(
        GET_DASHBOARD_URL,
        queryParameters: <String, dynamic>{
          'sellerId': sellerId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error getting dashboard link');
      }
      final link =
          (result.data!['data'] as Map<String, dynamic>)['url'] as String;
      if (link == null) {
        throw Exception('Error getting dashboard link');
      }
      return link;
    } on Exception catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<bool> isStripeSetupComplete(String sellerId) async {
    try {
      final result = await apiService.get<Map>(
        CHECK_IF_STRIPE_SETUP_COMPLETE,
        queryParameters: <String, dynamic>{
          'sellerId': sellerId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error checking if stripe setup is complete');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String> createAccount({
    required String email,
    required String businessType,
  }) async {
    try {
      final result = await apiService
          .post<Map>(CREATE_ACCOUNT, null, queryParameters: <String, dynamic>{
        'email': email,
        'business_type': businessType,
      });
      if (result.statusCode != 200) {
        throw Exception('Error creating account');
      }
      final accountId =
          (result.data!['data'] as Map<String, dynamic>)['url'] as String?;
      if (accountId == null) {
        throw Exception('Error creating account');
      }
      return accountId;
    } on Exception catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<bool> deleteAccount({
    required String sellerId,
    required String userId,
  }) async {
    try {
      final result = await apiService.delete<Map>(
        DELETE_ACCOUNT,
        queryParameters: <String, dynamic>{
          'sellerId': sellerId,
          'userId': userId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error deleting account');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> cancelAndRefund({
    required String orderId,
    required String orderItemId,
  }) async {
    try {
      final result = await apiService.delete<Map>(
        CANCEL_AND_REFUND,
        queryParameters: <String, dynamic>{
          'orderId': orderId,
          'orderItemId': orderItemId,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error cancelling and refunding');
      }
      return true;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getPaymentIntent(
    String orderId, {
    String? currency,
    int? appFeeInCents,
  }) async {
    try {
      final result = await apiService.post<Map>(
        CREATE_PAYMENT_INTENT,
        null,
        queryParameters: <String, dynamic>{
          'orderId': orderId,
          'currency': currency,
          'appFeeInCents': appFeeInCents,
        },
      );
      if (result.statusCode != 200) {
        throw Exception('Error getting payment intent');
      }
      final paymentIntent = result.data as Map<String, dynamic>?;
      if (paymentIntent == null) {
        throw Exception('Error getting payment intent');
      }
      return paymentIntent;
    } on Exception catch (e) {
      log(e.toString());
      return <String, dynamic>{};
    }
  }
}
