import 'package:cartisan/app/controllers/cart_controller.dart';
import 'package:cartisan/app/controllers/cart_page_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/cart/components/cart_item_card.dart';
import 'package:cartisan/app/modules/cart/components/delete_cart_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(
      init: CartController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
              : controller.isCartEmpty
                  ? Center(child: Text('Cart is empty'))
                  : ListView.separated(
                      itemCount: controller.cart.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemBuilder: (context, index) => CartItemCard(
                        cartItem: controller.cart[index],
                        deleteCallback: () {
                          Get.dialog<void>(DeleteCartItemDialog(
                            deleteConfirmationCallback: () {
                              controller.deleteCartItem(
                                controller.cart[index].cartItemId,
                              );
                              Get.back<void>();
                              controller.getCart();
                            },
                          ));
                        },
                      ),
                    ),
          bottomSheet: Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                controller.isCartEmpty
                    ? Get.back<void>()
                    : Get.find<CartPageController>().animateInitialPageToNext();
              },
              child: Container(
                height: 68.h,
                width: double.maxFinite,
                alignment: Alignment.center,
                color: AppColors.kPrimary,
                child: Text(
                  controller.isCartEmpty ? 'Back to home' : 'Proceed',
                  style: AppTypography.kLight16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
