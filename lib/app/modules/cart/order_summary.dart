import 'package:cartisan/app/controllers/address_controller.dart';
import 'package:cartisan/app/controllers/cart_controller.dart';
import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/controllers/checkout_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/cart/components/cart_item_card.dart';
import 'package:cartisan/app/modules/cart/components/order_summary_card.dart';
import 'package:cartisan/app/modules/cart/success_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final ac = Get.find<AddressController>();
  final cartController = Get.find<CartController>();
  final checkoutController = Get.find<CheckoutController>();
  @override
  Widget build(BuildContext context) {
    return GetX<CheckoutController>(
      init: CheckoutController(),
      builder: (controller) {
        controller.generateOrder();
        if (controller.order == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        double totalDelivery = 0;
        double totalTax = 0;
        controller.order!.orderItems
            .map<void>((e) => totalDelivery += e.deliveryCost);
        controller.order!.orderItems.map<void>((e) => totalTax += e.tax);
        return Scaffold(
          body: ListView(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
            children: [
              Text(
                'Shipping Address',
                style: AppTypography.kMedium16,
              ),
              SizedBox(height: AppSpacing.fourteenVertical),
              AddressCard(
                addressModel: ac.selectedAddress!,
                changeAddressCallback: () {
                  Get.find<CartPageController>().jumpToIndex(1);
                  Get.find<CartPageController>().updateStatus(
                    index: 1,
                    status: true,
                  );
                },
              ),
              SizedBox(height: AppSpacing.fourteenVertical),
              Text(
                'Item Summary',
                style: AppTypography.kMedium16,
              ),
              SizedBox(height: AppSpacing.fourteenVertical),
              ListView.separated(
                itemCount: cartController.cart.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 15.h),
                itemBuilder: (context, index) => CartItemCard(
                  cartItem: cartController.cart[index],
                  isOrderSummaryView: true,
                ),
              ),
              SizedBox(height: AppSpacing.fourteenVertical),
              Text(
                'Order Summary',
                style: AppTypography.kMedium16,
              ),
              SizedBox(height: AppSpacing.fourteenVertical),
              OrderSummaryCard(
                serviceFee: r'$1.00',
                deliveryCost: '\$$totalDelivery',
                taxAmount: '\$$totalTax',
              ),
              SizedBox(height: 20.h),
            ],
          ),
          bottomSheet: Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                controller.pay(controller.order!);
              },
              child: Container(
                height: 68.h,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                color: AppColors.kPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pay Now',
                      style: AppTypography.kMedium18,
                    ),
                    Text(
                      '\$ ${controller.order!.total}',
                      style: AppTypography.kMedium18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
