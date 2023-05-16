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
  }) : sellerStripeId = '';
}
