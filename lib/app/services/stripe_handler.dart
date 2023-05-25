// ignore_for_file: use_setters_to_change_properties

import 'package:cartisan/app/api_classes/payment_api.dart';

class StripeHandler {
  static StripeHandler? _self;
  final paymentApi = PaymentAPI();

  Map<String, dynamic>? paymentMethod;
  // Self Instance of Class.

  late String? _buyersID;

  factory StripeHandler() {
    _self ??= StripeHandler._internal();
    return _self!;
  }

  StripeHandler._internal();

  Future<String> getSellerUrl(
    String email,
    bool isIndividual,
  ) async {
    final type = isIndividual ? 'individual' : 'company';
    final result =
        await paymentApi.createAccount(email: email, businessType: type);
    return result;
  }

  void setBuyersID(String buyersID) {
    _buyersID = buyersID;
  }

  String getBuyersID() => _buyersID!;

  Map getPaymentMethod() => paymentMethod!;

  Future<bool> deleteConnectAccount(
    String userId,
    String sellerID,
  ) async {
    final result =
        await paymentApi.deleteAccount(sellerId: sellerID, userId: userId);
    return result;
  }

  Future<String> getDashboardLink(String stripeUserID) async {
    final result = await paymentApi.getDashboardLink(stripeUserID);
    return result;
  }
}
