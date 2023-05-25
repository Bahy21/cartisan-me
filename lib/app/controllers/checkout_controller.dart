import 'dart:developer';

import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/api_classes/payment_api.dart';
import 'package:cartisan/app/controllers/address_controller.dart';
import 'package:cartisan/app/controllers/cart_controller.dart';
import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/order_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:cartisan/app/modules/widgets/dialogs/loading_dialog.dart';
import 'package:cartisan/app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final uc = Get.find<UserController>();
  final ac = Get.find<AddressController>();
  final db = Database();
  final paymentApi = PaymentAPI();
  bool get generatedOrder => _generatedOrder.value;
  OrderModel? get order => _order.value;
  RxBool _generatedOrder = false.obs;
  Rx<OrderModel?> _order = Rx<OrderModel?>(null);
  UserModel get user => uc.currentUser!;

  Future<void> pay(OrderModel order) async {
    final paymentIntent = await _createPaymentIntent(order.orderId);
    log(paymentIntent.toString());
    final status = await _initPaymentSheet(
      paymentIntent['customer'] as String,
      paymentIntent['client_secret'] as String,
      paymentIntent['ephemeralKey'] as String,
    );

    if (status) {
      Get.dialog<Widget>(LoadingDialog(), barrierDismissible: false);
      for (final orderItem in order.orderItems) {
        await _increaseSellCount(orderItem.productId);
      }
      // await Database()
      //     .ordersCollection
      //     .doc(order.orderId)
      //     .set(order.toMap(), SetOptions(merge: true));

      Get.back<void>();
      Get.find<CartPageController>().animateInitialPageToNext();
    } else {
      await showErrorDialog('Error paying for order');
      Get.back<void>();
    }
  }

  Future<void> generateOrder() async {
    if (generatedOrder && order != null) {
      return;
    }
    final address = Get.find<AddressController>().selectedAddress!;
    _order.value = await Get.find<CartController>().processCartItems(address);
    _generatedOrder.value = true;
  }

  Future<Map<String, dynamic>> _createPaymentIntent(String orderId) async {
    final result = await paymentApi.getPaymentIntent(orderId);
    log('result of payment intent $result');
    return result;
  }

  Future<bool> _initPaymentSheet(
    String customerId,
    String paymentIntentClientSecret,
    String ephemeralKey,
  ) async {
    try {
      final billingDetails = stripe.BillingDetails(
        name: user.profileName,
        email: user.email,
        phone: '',
        address: stripe.Address(
          city: user.city,
          country: user.country,
          line1: '',
          line2: '',
          postalCode: '',
          state: '',
        ),
      );
      final stripeInstance = stripe.Stripe.instance;
      await stripeInstance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Cartisan Exchange',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          applePay: const stripe.PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'US',
          ),
          style: ThemeMode.dark,
          billingDetails: billingDetails,
        ),
      );
      await stripeInstance.presentPaymentSheet();
      return true;
    } on Exception catch (e) {
      log(e.toString());
      if (e is stripe.StripeException) {
        await showErrorDialog('Error from Stripe: ${e.error.localizedMessage}');
        return false;
      } else {
        await showErrorDialog('Error is: ${e.toString()}');
        return false;
      }
    }
  }

  Future<void> _increaseSellCount(String postId) async {
    try {
      await db.postsCollection.doc(postId).update({
        'sellCount': FieldValue.increment(1),
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
