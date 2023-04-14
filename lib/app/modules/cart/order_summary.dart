import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/components/address_card.dart';
import 'package:cartisan/app/modules/cart/components/cart_item_card.dart';
import 'package:cartisan/app/modules/cart/components/order_summary_card.dart';
import 'package:cartisan/app/modules/cart/success_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        children: [
          Text(
            'Shipping Address',
            style: AppTypography.kMedium16,
          ),
          SizedBox(height: AppSpacing.fourteenVertical),
          AddressCard(
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
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            itemBuilder: (context, index) => const CartItemCard(
              isOrderSummaryView: true,
            ),
          ),
          SizedBox(height: AppSpacing.fourteenVertical),
          Text(
            'Order Summary',
            style: AppTypography.kMedium16,
          ),
          SizedBox(height: AppSpacing.fourteenVertical),
          const OrderSummaryCard(
            serviceFee: r'$4,00',
            deliveryCost: r'$4,00',
            taxAmount: r'$4,00',
          ),
          SizedBox(height: 20.h),
        ],
      ),
      bottomSheet: Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            Get.to<Widget>(() => const SuccessPageView());
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
                  r'$ 32.70',
                  style: AppTypography.kMedium18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
